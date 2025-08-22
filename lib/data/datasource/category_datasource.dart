import 'package:dio/dio.dart';
import 'package:ecommerce/data/model/category_model.dart';
import 'package:ecommerce/di/di.dart';
import 'package:ecommerce/util/api_exception.dart';

abstract class ICategoryDataSource {
  Future<List<CategoryModel>> getCategories();
}

class CategoryLocalDatasource extends ICategoryDataSource {
  // Sample category data - You can modify this data as needed
  static final List<CategoryModel> _sampleCategories = [
    CategoryModel(
      'categories',
      'smartphones',
      'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=200',
      'Smartphones',
      '6C5CE7',
      'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=50',
    ),
    CategoryModel(
      'categories',
      'laptops',
      'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=200',
      'Laptops',
      '00DFA2',
      'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=50',
    ),
    CategoryModel(
      'categories',
      'audio',
      'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=200',
      'Audio',
      'FF6B9D',
      'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=50',
    ),
    CategoryModel(
      'categories',
      'cameras',
      'https://images.unsplash.com/photo-1606983340126-99ab4feaa64a?w=200',
      'Cameras',
      'FFD93D',
      'https://images.unsplash.com/photo-1606983340126-99ab4feaa64a?w=50',
    ),
    CategoryModel(
      'categories',
      'wearables',
      'https://images.unsplash.com/photo-1434494878577-86c23bcb06b9?w=200',
      'Wearables',
      '00F5A0',
      'https://images.unsplash.com/photo-1434494878577-86c23bcb06b9?w=50',
    ),
    CategoryModel(
      'categories',
      'shoes',
      'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=200',
      'Shoes',
      'FF5757',
      'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=50',
    ),
    CategoryModel(
      'categories',
      'clothing',
      'https://images.unsplash.com/photo-1525507119028-ed4c629a60a3?w=200',
      'Clothing',
      '5A4FCF',
      'https://images.unsplash.com/photo-1525507119028-ed4c629a60a3?w=50',
    ),
    CategoryModel(
      'categories',
      'accessories',
      'https://images.unsplash.com/photo-1577512700736-27d50b467a7c?w=200',
      'Accessories',
      '6C7293',
      'https://images.unsplash.com/photo-1577512700736-27d50b467a7c?w=50',
    ),
  ];

  @override
  Future<List<CategoryModel>> getCategories() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_sampleCategories);
  }
}

// Keep the original remote datasource for reference
class CategoryRemoteDatasource extends ICategoryDataSource {
  final Dio _dio = locator.get();

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      var response = await _dio.get('collections/category/records');
      return (response.data['items'] as List)
          .map<CategoryModel>(
              (jsonObject) => CategoryModel.fromMapJson(jsonObject))
          .toList();
    } on DioException catch (ex) {
      throw ApiException(
        ex.response?.statusCode ?? 0,
        ex.response?.data?['message'] ?? 'Unknown error occurred',
      );
    } catch (ex) {
      throw ApiException(0, 'Unknown error occurred');
    }
  }
}
