import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ossos_task/imports.dart';

class TestFeatureBloc extends Bloc<TestFeatureEvent, BaseBlocState> {
  TestFeatureBloc() : super(TestFeatureState()) {
    on<getTestFeatureEvent>(_getTestFeature);
  }

  FutureOr<void> _getTestFeature(
    getTestFeatureEvent event,
    Emitter<BaseBlocState> emit,
  ) async {
    // in case of loading
    emit(LoadingState());

    await Future.delayed(const Duration(seconds: 1));

    // in case of success
    emit(TestFeatureState(number: 3));

    // in case of failure
    // emit(ErrorState(errorMessage: "Problem has happened"));
  }
}
