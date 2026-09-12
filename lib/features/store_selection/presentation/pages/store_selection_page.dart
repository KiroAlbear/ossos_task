import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ossos_task/core/utils/product_utils.dart';
import 'package:ossos_task/imports.dart';

class StoreSelectionPage extends BaseStatefulWidget {

  const StoreSelectionPage({super.key,});

  @override
  State<StoreSelectionPage> createState() => _StoreSelectionPageState();
}

class _StoreSelectionPageState extends BaseStatefullState<StoreSelectionPage> {
  @override
  String? appBarTitle() => 'Select a store';

  @override
  bool canPop() => true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      BlocProvider.of<StoreSelectionBloc>(context).add(LoadStoresEvent());
    },);

    super.initState();
  }

  @override
  Widget getBody(BuildContext context) {
    return Builder(
      builder: (context) {
        void reload() {
          context.read<StoreSelectionBloc>().add(const LoadStoresEvent());
        }

        return BaseBloc<
          StoreSelectionBloc,
          BaseBlocState,
          StoreSelectionState
        >(
          errorWidget: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Unable to load stores.'),
                TextButton(onPressed: reload, child: const Text('Retry')),
              ],
            ),
          ),
          builder: (state) {
            if (state.stores.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('No stores available.'),
                    TextButton(
                      onPressed: reload,
                      child: const Text('Refresh'),
                    ),
                  ],
                ),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.stores.length,
                    itemBuilder: (context, index) {
                      final store = state.stores[index];
                      final selected = state.selectedStore?.id == store.id;
                      return ListTile(
                        key: ValueKey(store.id),
                        title: Text(store.name),
                        selected: selected,
                        trailing: Icon(
                          selected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                        ),
                        onTap: () => context.read<StoreSelectionBloc>().add(
                          SelectStoreEvent(store.id),
                        ),
                      );
                    },
                  ),
                ),
                SafeArea(
                  top: false,
                  child: ElevatedButton(
                    onPressed: state.selectedStore == null
                        ? null
                        : () {
                        ProductUtils().saveStoreId(state.selectedStore!.name.toString());
                        Routes.navigateToScreen(Routes.inventorySessionScreen, NavigationType.pushNamed, context,arguments: state.selectedStore!.name.toString());
                      },
                    child: const Text('Continue'),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
