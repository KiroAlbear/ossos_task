import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ossos_task/core/base/base_bloc_state.dart';

import '../../domain/failures/inventory_session_conflict_failure.dart';
import '../../domain/use_cases/inventory_session_usecase.dart';
import 'inventory_session_event.dart';
import 'inventory_session_state.dart';

class InventorySessionBloc extends Bloc<InventorySessionEvent, BaseBlocState> {
  final InventorySessionUseCase _useCase;
  bool _submitting = false;

  InventorySessionBloc(this._useCase) : super(InitialState()) {
    on<SubmitInventorySessionEvent>(_submitInventorySession);
  }

  Future<void> _submitInventorySession(
    SubmitInventorySessionEvent event,
    Emitter<BaseBlocState> emit,
  ) async {
    if (_submitting) return;
    _submitting = true;
    emit(LoadingState());
    try {
      final result = await _useCase(
        InventorySessionParams(request: event.request),
      );
      if (emit.isDone) return;
      result.fold((failure) {
        if (failure is InventorySessionConflictFailure) {
          emit(
            InventorySessionConflictState(
              conflict: failure.conflict,
              request: event.request,
            ),
          );
        } else {
          emit(ErrorState(errorMessage: failure.message));
        }
      }, (session) => emit(InventorySessionState(session: session)));
    } catch (_) {
      if (!emit.isDone) {
        emit(
          ErrorState(
            errorMessage:
                'Unable to submit the inventory session. Please retry.',
          ),
        );
      }
    } finally {
      _submitting = false;
    }
  }
}
