import 'package:dartz/dartz.dart';
import 'package:ossos_task/imports.dart';

abstract class ProductPageRemoteDataSource {
  Future<Either<Failure, ProductPageModel>> fetchProducts({
    required int page,
    int limit = 20,
  });
}

class ProductPageRemoteDataSourceImpl
    with ApiHelperMixin, RepositoryHelperMixin
    implements ProductPageRemoteDataSource {
  ProductPageRemoteDataSourceImpl();

  @override
  Future<Either<Failure, ProductPageModel>> fetchProducts({
    required int page,
    int limit = 10,
  }) async {
    if (page < 1) {
      return const Left(CustomFailure('Page must be greater than zero.'));
    }
    if (limit < 1) {
      return const Left(CustomFailure('Limit must be greater than zero.'));
    }

    final products = [
      ProductModel(
        id: 101,
        name: 'Wireless Barcode Scanner',
        sku: 'SCN-101',
        barcode: '6221234567890',
        systemQuantity: 20,
        version: 5,
        updatedAt: DateTime.parse('2026-09-06T10:00:00Z'),
      ),
      ProductModel(
        id: 102,
        name: 'Receipt Printer',
        sku: 'PRN-102',
        barcode: '6221234567891',
        systemQuantity: 12,
        version: 3,
        updatedAt: DateTime.parse('2026-09-06T10:05:00Z'),
      ),
      ProductModel(
        id: 103,
        name: 'Cash Drawer',
        sku: 'DRW-103',
        barcode: '6221234567892',
        systemQuantity: 8,
        version: 1,
        updatedAt: DateTime.parse('2026-09-06T10:10:00Z'),
      ),
      ProductModel(
        id: 104,
        name: 'Touchscreen POS Terminal',
        sku: 'POS-104',
        barcode: '6221234567893',
        systemQuantity: 15,
        version: 1,
        updatedAt: DateTime.parse('2026-09-06T11:00:00Z'),
      ),
      ProductModel(
        id: 105,
        name: 'Thermal Paper Roll',
        sku: 'PPR-105',
        barcode: '6221234567894',
        systemQuantity: 120,
        version: 1,
        updatedAt: DateTime.parse('2026-09-06T11:03:00Z'),
      ),
      ProductModel(
        id: 106,
        name: 'Label Printer',
        sku: 'LBL-106',
        barcode: '6221234567895',
        systemQuantity: 9,
        version: 1,
        updatedAt: DateTime.parse('2026-09-06T11:06:00Z'),
      ),
      ProductModel(
        id: 107,
        name: 'Barcode Labels',
        sku: 'BCL-107',
        barcode: '6221234567896',
        systemQuantity: 200,
        version: 1,
        updatedAt: DateTime.parse('2026-09-06T11:09:00Z'),
      ),
      ProductModel(
        id: 108,
        name: 'Card Reader',
        sku: 'CRD-108',
        barcode: '6221234567897',
        systemQuantity: 25,
        version: 1,
        updatedAt: DateTime.parse('2026-09-06T11:12:00Z'),
      ),
      ProductModel(
        id: 109,
        name: 'Customer Display',
        sku: 'DSP-109',
        barcode: '6221234567898',
        systemQuantity: 11,
        version: 1,
        updatedAt: DateTime.parse('2026-09-06T11:15:00Z'),
      ),
      ProductModel(
        id: 110,
        name: 'POS Keyboard',
        sku: 'KEY-110',
        barcode: '6221234567899',
        systemQuantity: 18,
        version: 1,
        updatedAt: DateTime.parse('2026-09-06T11:18:00Z'),
      ),
      ProductModel(
        id: 111,
        name: 'Optical Mouse',
        sku: 'MSE-111',
        barcode: '6221234567900',
        systemQuantity: 30,
        version: 1,
        updatedAt: DateTime.parse('2026-09-06T11:21:00Z'),
      ),
      ProductModel(
        id: 112,
        name: 'USB Hub',
        sku: 'HUB-112',
        barcode: '6221234567901',
        systemQuantity: 22,
        version: 1,
        updatedAt: DateTime.parse('2026-09-06T11:24:00Z'),
      ),
      ProductModel(
        id: 113,
        name: 'Ethernet Cable',
        sku: 'ETH-113',
        barcode: '6221234567902',
        systemQuantity: 50,
        version: 1,
        updatedAt: DateTime.parse('2026-09-06T11:27:00Z'),
      ),
      ProductModel(
        id: 114,
        name: 'Wi-Fi Router',
        sku: 'RTR-114',
        barcode: '6221234567903',
        systemQuantity: 14,
        version: 1,
        updatedAt: DateTime.parse('2026-09-06T11:30:00Z'),
      ),
      ProductModel(
        id: 115,
        name: 'Tablet Stand',
        sku: 'STD-115',
        barcode: '6221234567904',
        systemQuantity: 16,
        version: 1,
        updatedAt: DateTime.parse('2026-09-06T11:33:00Z'),
      ),
      ProductModel(
        id: 116,
        name: 'Power Adapter',
        sku: 'PWR-116',
        barcode: '6221234567905',
        systemQuantity: 35,
        version: 1,
        updatedAt: DateTime.parse('2026-09-06T11:36:00Z'),
      ),
      ProductModel(
        id: 117,
        name: 'Handheld Inventory Terminal',
        sku: 'HHT-117',
        barcode: '6221234567906',
        systemQuantity: 7,
        version: 1,
        updatedAt: DateTime.parse('2026-09-06T11:39:00Z'),
      ),
      ProductModel(
        id: 118,
        name: 'Digital Weighing Scale',
        sku: 'SCL-118',
        barcode: '6221234567907',
        systemQuantity: 10,
        version: 1,
        updatedAt: DateTime.parse('2026-09-06T11:42:00Z'),
      ),
      ProductModel(
        id: 119,
        name: 'Security Tag Remover',
        sku: 'TAG-119',
        barcode: '6221234567908',
        systemQuantity: 13,
        version: 1,
        updatedAt: DateTime.parse('2026-09-06T11:45:00Z'),
      ),
      ProductModel(
        id: 120,
        name: 'Receipt Printer Ribbon',
        sku: 'RBN-120',
        barcode: '6221234567909',
        systemQuantity: 40,
        version: 1,
        updatedAt: DateTime.parse('2026-09-06T11:48:00Z'),
      ),
    ];

    final totalPages = (products.length / limit).ceil();
    final paginatedProducts = products
        .skip((page - 1) * limit)
        .take(limit)
        .toList();
    final productPageModel = ProductPageModel(
      data: paginatedProducts,
      page: page,
      totalPages: totalPages,
      totalItems: products.length,
    );

    await Future<void>.delayed(const Duration(seconds: 1));
    return Right(productPageModel);
  }
}
