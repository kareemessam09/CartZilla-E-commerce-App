import 'package:dio/dio.dart';
import 'package:ecommerce/data/model/product_model.dart';
import 'package:ecommerce/di/di.dart';
import 'package:ecommerce/util/api_exception.dart';

abstract class ICategoryProductDataSource {
  Future<List<ProductModel>> getProductsByCategoryId(String categoryId);
}

class CategoryProductLocalDatasource extends ICategoryProductDataSource {
  // Sample products organized by category
  static final Map<String, List<ProductModel>> _productsByCategory = {
    'smartphones': [
      ProductModel(
        '1',
        'electronics',
        'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400',
        'Latest iPhone with advanced camera system and A17 Pro chip.',
        200,
        1299,
        'Best Seller',
        'iPhone 15 Pro',
        25,
        'smartphones',
      ),
      ProductModel(
        '9',
        'electronics',
        'https://images.unsplash.com/photo-1598300042247-d088f8ab3a91?w=400',
        'Premium Android smartphone with excellent camera and performance.',
        150,
        899,
        'Hotest',
        'Samsung Galaxy S24',
        18,
        'smartphones',
      ),
    ],
    'laptops': [
      ProductModel(
        '4',
        'electronics',
        'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=400',
        'High-performance laptop perfect for gaming and creative work.',
        300,
        2199,
        'Hotest',
        'ASUS ROG Laptop',
        8,
        'laptops',
      ),
      ProductModel(
        '10',
        'electronics',
        'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=400',
        'Ultra-portable MacBook perfect for professionals and students.',
        200,
        1599,
        'Best Seller',
        'MacBook Air M2',
        12,
        'laptops',
      ),
    ],
    'audio': [
      ProductModel(
        '3',
        'electronics',
        'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400',
        'Premium wireless headphones with noise cancellation.',
        80,
        399,
        'Best Seller',
        'Sony WH-1000XM5',
        12,
        'audio',
      ),
      ProductModel(
        '8',
        'electronics',
        'https://images.unsplash.com/photo-1583394838336-acd977736f90?w=400',
        'Wireless earbuds with active noise cancellation.',
        70,
        279,
        'Hotest',
        'AirPods Pro 2',
        30,
        'audio',
      ),
    ],
    // Add more categories as needed
  };

  @override
  Future<List<ProductModel>> getProductsByCategoryId(String categoryId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Return all products if special category ID or products for specific category
    if (categoryId == 'qnbj8d6b9lzzpn8' || categoryId == 'all') {
      // Return all products from all categories
      List<ProductModel> allProducts = [];
      for (var products in _productsByCategory.values) {
        allProducts.addAll(products);
      }
      return allProducts;
    } else {
      return _productsByCategory[categoryId] ?? [];
    }
  }
}

// Keep the original remote datasource for reference
class CategoryProductRemoteDatasource extends ICategoryProductDataSource {
  final Dio _dio = locator.get();

  @override
  Future<List<ProductModel>> getProductsByCategoryId(String categoryId) async {
    try {
      Map<String, String> qParams = {'filter': 'category="$categoryId"'};

      Response<dynamic> response;
      if (categoryId == 'qnbj8d6b9lzzpn8') {
        response = await _dio.get('collections/products/records');
      } else {
        response = await _dio.get('collections/products/records',
            queryParameters: qParams);
      }

      return response.data['items']
          .map<ProductModel>((jsonObject) => ProductModel.fromJson(jsonObject))
          .toList();
    } on DioException catch (ex) {
      throw ApiException(ex.response?.statusCode, ex.response?.data['message']);
    } catch (e) {
      throw ApiException(0, 'unknown error');
    }
  }
}
