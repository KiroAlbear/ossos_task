import 'package:flutter/material.dart';

import '../../data/models/inventory_session_conflict_model.dart';
import '../../data/models/inventory_session_request_model.dart';

class ProductConflictsSheet extends StatelessWidget {
  final InventorySessionConflictModel conflict;
  final InventorySessionRequestModel request;

  const ProductConflictsSheet({
    super.key,
    required this.conflict,
    required this.request,
  });

  @override
  Widget build(BuildContext context) {
    final names = {for (final item in request.items) item.productId: item.name};
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.65,
      ),
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const Text(
            'Product conflicts',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          if (conflict.conflicts.isEmpty) const Text('No product conflicts.'),
          for (final product in conflict.conflicts)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      names[product.productId]?.trim().isNotEmpty == true
                          ? names[product.productId]!
                          : 'Product #${product.productId}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _quantity(
                      'Original system quantity',
                      product.originalSystemQuantity,
                    ),
                    _quantity(
                      'Current system quantity',
                      product.currentSystemQuantity,
                    ),
                    _quantity('Counted quantity', product.countedQuantity),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _quantity(String label, int value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Text(label)),
        const SizedBox(width: 12),
        Text('$value', style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    ),
  );
}
