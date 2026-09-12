import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ossos_task/config/config.dart';
import 'package:ossos_task/core/utils/app_utils.dart';

import 'base_bloc_state.dart';

class BaseBloc<
  B extends StateStreamable<S>,
  S extends BaseBlocState,
  T extends SuccessState
>
    extends StatefulWidget {
  final Widget? Function(T) builder;
  final bool Function(S, S)? buildWhen;
  final void Function(BuildContext, S)? listener;
  final bool Function(S, S)? listenWhen;
  final Widget loadingWidget;
  final Widget emptyWidget;
  final Widget errorWidget;
  final bool showLoadingOverlay;
  final bool horizontalPadding;
  final bool showErrorToast;

  const BaseBloc({
    super.key,
    required this.builder,
    this.buildWhen,
    this.listener,
    this.listenWhen,
    this.loadingWidget = const CircularProgressIndicator(color: Colors.blue,),
    this.emptyWidget = const SizedBox(),
    this.errorWidget = const SizedBox(),
    this.showLoadingOverlay = false,
    this.horizontalPadding = false,
    this.showErrorToast = true
  });

  @override
  State<BaseBloc<B, S, T>> createState() => _BaseBlocState<B, S, T>();
}

class _BaseBlocState<
  B extends StateStreamable<S>,
  S extends BaseBlocState,
  T extends SuccessState
>
    extends State<BaseBloc<B, S, T>> {
  T? _lastSuccessState;

  Widget _buildSuccessWidget(T state) {
    return Padding(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: widget.horizontalPadding ? 16.0 : 0,
      ),
      child: widget.builder(state) ?? const SizedBox(),
    );
  }

  Widget _buildLoadingOverlay(Widget child) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        PositionedDirectional(
          top: 0,
          bottom: 0,
          start: -16.0,
          end: -16.0,
          child: AbsorbPointer(
            child: Container(
              color: GenericColors.getColors(
                context,
                GenericColors.blue148_white,
              ).withAlpha(60),
              child: Center(child: widget.loadingWidget),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainWidget(BuildContext context, S state) {
    // if state loading is null and error message is empty
    if (state is LoadingState) {
      if (widget.showLoadingOverlay && _lastSuccessState != null) {
        return _buildLoadingOverlay(_buildSuccessWidget(_lastSuccessState!));
      } else {
        return Center(child: widget.loadingWidget);
      }
    } else if (state is EmptyState) {
      return const Center(child: Icon(Icons.error));
    } else if (state is ErrorState) {
      if (_lastSuccessState != null) {
        return _buildSuccessWidget(_lastSuccessState!);
      }

      return widget.errorWidget;
    } else if (state is SuccessState) {
      _lastSuccessState = state as T;
      return _buildSuccessWidget(_lastSuccessState!);
      // return SizedBox()
    } else {
      return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<B, S>(
      buildWhen: (S previous, S current) {
        if (widget.buildWhen == null) {
          return previous != current;
        } else {
          return widget.buildWhen!(previous, current);
        }
      },
      listenWhen: (previous, current) {
        if (widget.listenWhen == null) {
          return previous != current;
        } else {
          return widget.listenWhen!(previous, current);
        }
      },
      listener: (BuildContext context, S state) {
        if(state is ErrorState && state.errorMessage != null && widget.showErrorToast ){
          _showErrorToast(context, state.errorMessage);
        }

        widget.listener?.call(context, state);
      },
      builder: (BuildContext context, S state) {
        return _buildMainWidget(context, state);
      },
    );
  }

  void _showErrorToast(BuildContext context, String? errorMessage) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      if (errorMessage != null && errorMessage.isNotEmpty) {
        AppUtils.showAppToast(context: context, message: errorMessage);
      }
    });
  }
}
