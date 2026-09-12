import 'dart:convert';

import 'package:ossos_task/core/core.dart';

import '../../features/inventory_session/data/models/inventory_session_request_model.dart';
import '../services/secure_storage/secure_storage_manager.dart';

class ProductUtils {
  Future<void> saveStoreId(String storeId) async {
    await SecureStorageManager.getInstance().setValue(SecureStorageKeys.storeIdKey, storeId);
  }

  Future<String?> getStoreId() async {
    return await SecureStorageManager.getInstance().getValue(SecureStorageKeys.storeIdKey);
  }

  Future<Map<int, int>> getProductsSharedPrefrences() async {
    final Map<int, int> _restoredCounts = {};

    final String storeId =  await getStoreId()??"";
    final raw = await SecureStorageManager.getInstance().getValue(
      '${SecureStorageKeys.productCountsKey}$storeId',
    );

    if (raw != null) {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      for (final entry in data.entries) {
        final id = int.tryParse(entry.key);
        if (id != null && entry.value is int && (entry.value as int) >= 0) {
          _restoredCounts[id] = entry.value as int;
        }
      }
    }
    return _restoredCounts;
  }

  Future<void> savePproductsSharedPrefrence(

    Map<int, int> products,
  ) async {
    final String storeId = await getStoreId() ?? "";
    await SecureStorageManager.getInstance().setObject(
      '${SecureStorageKeys.productCountsKey}$storeId',
      products.map((id, count) => MapEntry(id.toString(), count)),
    );
  }

  Future<void> saveSubmittedProducts(List<Map<String,dynamic>> items) async {
    final String storeId = await getStoreId() ?? "";
    await SecureStorageManager.getInstance().setObject(
      '${SecureStorageKeys.submittedProductCountsKey}$storeId',
      items,
    );
  }

  Future<List<InventorySessionItemModel>> getSubmittedProducts() async {
    final String storeId = await getStoreId() ?? "";

    final raw = await SecureStorageManager.getInstance().getValue(
      '${SecureStorageKeys.submittedProductCountsKey}$storeId',
    );
    if (raw == null) return [];
    return (jsonDecode(raw) as List<dynamic>)
        .map(
          (item) =>
          InventorySessionItemModel.fromJson(item as Map<String, dynamic>),
    )
        .toList();

  }

}
