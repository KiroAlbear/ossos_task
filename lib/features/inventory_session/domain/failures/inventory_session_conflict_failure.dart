import 'package:ossos_task/core/models/error_handling_models/src/failure.dart';

import '../../data/models/inventory_session_conflict_model.dart';

class InventorySessionConflictFailure extends Failure {
  final InventorySessionConflictModel conflict;

  const InventorySessionConflictFailure(this.conflict)
    : super('Some products have changed since this inventory session started.');
}
