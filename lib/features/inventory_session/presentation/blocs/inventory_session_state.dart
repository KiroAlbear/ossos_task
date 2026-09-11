import 'package:ossos_task/core/base/base_bloc_state.dart';

import '../../data/models/inventory_session_conflict_model.dart';
import '../../data/models/inventory_session_model.dart';
import '../../data/models/inventory_session_request_model.dart';

class InventorySessionState extends SuccessState {
  final InventorySessionModel session;

  InventorySessionState({required this.session});
}

class InventorySessionConflictState extends ErrorState {
  final InventorySessionConflictModel conflict;
  final InventorySessionRequestModel request;

  InventorySessionConflictState({required this.conflict, required this.request})
    : super(
        errorMessage:
            'Some products have changed since this inventory session started.',
      );
}
