import 'package:dio/dio.dart';
import 'package:ecommerce/data/model/product_model.dart';
import 'package:ecommerce/di/di.dart';
import 'package:ecommerce/util/api_exception.dart';

abstract class IProductDataSource {
  Future<List<ProductModel>> getProducts();
  Future<List<ProductModel>> getHottest();
  Future<List<ProductModel>> getBeastSeller();
}

class ProductLocalDatasource extends IProductDataSource {
  // Sample product data - You can modify this data as needed
  static final List<ProductModel> _sampleProducts = [
    ProductModel(
      '1',
      'electronics',
      'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400',
      'Latest iPhone with advanced camera system and A17 Pro chip. Experience the future of smartphones.',
      200,
      1299,
      'Best Seller',
      'iPhone 15 Pro',
      25,
      'smartphones',
    ),
    ProductModel(
      '2',
      'electronics',
      'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400',
      'Comfortable running shoes with advanced cushioning technology for all-day comfort.',
      50,
      179,
      'Hotest',
      'Nike Air Max 270',
      15,
      'shoes',
    ),
    ProductModel(
      '3',
      'electronics',
      'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400',
      'Premium wireless headphones with noise cancellation and 30-hour battery life.',
      80,
      399,
      'Best Seller',
      'Sony WH-1000XM5',
      12,
      'audio',
    ),
    ProductModel(
      '4',
      'electronics',
      'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=400',
      'High-performance laptop perfect for gaming and creative work with RTX graphics.',
      300,
      2199,
      'Hotest',
      'ASUS ROG Laptop',
      8,
      'laptops',
    ),
    ProductModel(
      '5',
      'electronics',
      'https://images.unsplash.com/photo-1434494878577-86c23bcb06b9?w=400',
      'Stylish watch with fitness tracking and heart rate monitoring capabilities.',
      120,
      449,
      'Best Seller',
      'Apple Watch Series 9',
      20,
      'wearables',
    ),
    ProductModel(
      '6',
      'electronics',
      'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=400',
      'Professional camera with 4K video recording and advanced autofocus system.',
      400,
      1899,
      'Hotest',
      'Canon EOS R6',
      6,
      'cameras',
    ),
    ProductModel(
      '7',
      'electronics',
      'https://images.unsplash.com/photo-1529336953128-a85760f58cb5?w=400',
      'Comfortable cotton t-shirt with modern fit and premium quality fabric.',
      10,
      39,
      'Best Seller',
      'Premium Cotton T-Shirt',
      50,
      'clothing',
    ),
    ProductModel(
      '8',
      'electronics',
      'https://images.unsplash.com/photo-1583394838336-acd977736f90?w=400',
      'Wireless earbuds with active noise cancellation and premium sound quality.',
      70,
      279,
      'Hotest',
      'AirPods Pro 2',
      30,
      'audio',
    ),
  ];

  @override
  Future<List<ProductModel>> getProducts() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_sampleProducts);
  }

  @override
  Future<List<ProductModel>> getBeastSeller() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _sampleProducts
        .where((product) => product.popularity == 'Best Seller')
        .toList();
  }

  @override
  Future<List<ProductModel>> getHottest() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _sampleProducts
        .where((product) => product.popularity == 'Hotest')
        .toList();
  }
}

// Keep the original remote datasource for reference
class ProductRemoteDatasource extends IProductDataSource {
  final Dio _dio = locator.get();

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      var response = await _dio.get('collections/products/records');
      return response.data['items']
          .map<ProductModel>((jsonObject) => ProductModel.fromJson(jsonObject))
          .toList();
    } on DioException catch (ex) {
      throw ApiException(ex.response?.statusCode, ex.response?.data['message']);
    } catch (ex) {
      throw ApiException(0, 'unknown error');
    }
  }

  @override
  Future<List<ProductModel>> getBeastSeller() async {
    try {
      Map<String, String> qParams = {
        'filter': 'popularity="Best Seller"',
      };
      var response = await _dio.get('collections/products/records',
          queryParameters: qParams);
      return response.data['items']
          .map<ProductModel>((jsonObject) => ProductModel.fromJson(jsonObject))
          .toList();
    } on DioException catch (ex) {
      throw ApiException(ex.response?.statusCode, ex.response?.data['message']);
    } catch (ex) {
      throw ApiException(0, 'unknown error');
    }
  }

  @override
  Future<List<ProductModel>> getHottest() async {
    try {
      Map<String, String> qParams = {
        'filter': 'popularity="Hotest"',
      };
      var response = await _dio.get('collections/products/records',
          queryParameters: qParams);
      return response.data['items']
          .map<ProductModel>((jsonObject) => ProductModel.fromJson(jsonObject))
          .toList();
    } on DioException catch (ex) {
      throw ApiException(ex.response?.statusCode, ex.response?.data['message']);
    } catch (ex) {
      throw ApiException(0, 'unknown error');
    }
  }
}
