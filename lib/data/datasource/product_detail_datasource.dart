import 'package:dio/dio.dart';
import 'package:ecommerce/data/model/category_model.dart';
import 'package:ecommerce/data/model/product_image_model.dart';
import 'package:ecommerce/data/model/product_variant.dart';
import 'package:ecommerce/data/model/product_property_model.dart';
import 'package:ecommerce/data/model/variant.dart';
import 'package:ecommerce/data/model/variant_type_model.dart';
import 'package:ecommerce/di/di.dart';
import 'package:ecommerce/util/api_exception.dart';

abstract class IProductDetailDatasource {
  Future<List<ProductImageModel>> getGallery(String productId);
  Future<List<VariantType>> getVariantTypes();
  Future<List<Variant>> getVariant(String productId);
  Future<List<ProductVariant>> getProductVariants(String productId);
  Future<CategoryModel> getProductCategory(String categoryId);
  Future<List<Property>> getProductProperties(String productId);
}

class ProductDetailLocalDatasource extends IProductDetailDatasource {
  // Sample product images
  static final Map<String, List<ProductImageModel>> _productImages = {
    '1': [
      ProductImageModel(
          'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600',
          '1'),
      ProductImageModel(
          'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=600',
          '1'),
      ProductImageModel(
          'https://images.unsplash.com/photo-1520923642038-b4259acecbd7?w=600',
          '1'),
    ],
    '2': [
      ProductImageModel(
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600',
          '2'),
      ProductImageModel(
          'https://images.unsplash.com/photo-1539185441755-769473a23570?w=600',
          '2'),
    ],
    // Add more as needed
  };

  // Sample categories
  static final Map<String, CategoryModel> _categories = {
    'smartphones': CategoryModel(
        'categories',
        'smartphones',
        'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=200',
        'Smartphones',
        '6C5CE7',
        ''),
    'laptops': CategoryModel(
        'categories',
        'laptops',
        'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=200',
        'Laptops',
        '00DFA2',
        ''),
    'audio': CategoryModel(
        'categories',
        'audio',
        'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=200',
        'Audio',
        'FF6B9D',
        ''),
  };

  @override
  Future<List<ProductImageModel>> getGallery(String productId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _productImages[productId] ?? [];
  }

  @override
  Future<CategoryModel> getProductCategory(String categoryId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _categories[categoryId] ??
        CategoryModel('', '', '', 'Unknown', '', '');
  }

  @override
  Future<List<Property>> getProductProperties(String productId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Sample properties
    return [
      Property('Screen Size', '6.1 inches'),
      Property('Storage', '128GB'),
      Property('RAM', '8GB'),
      Property('Battery', '3279 mAh'),
      Property('Camera', '48MP Main'),
    ];
  }

  @override
  Future<List<VariantType>> getVariantTypes() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      VariantType('color', 'color', 'Color', VariantTypeEnum.COLOR),
      VariantType('storage', 'storage', 'Storage', VariantTypeEnum.STORAGE),
    ];
  }

  @override
  Future<List<Variant>> getVariant(String productId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      Variant('var1', 'Blue', 'color', '4287f5', 0),
      Variant('var2', 'Black', 'color', '000000', 0),
      Variant('var3', '128GB', 'storage', '128', 50),
      Variant('var4', '256GB', 'storage', '256', 100),
    ];
  }

  @override
  Future<List<ProductVariant>> getProductVariants(String productId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    var variantTypes = await getVariantTypes();
    var variants = await getVariant(productId);

    return variantTypes.map((variantType) {
      var variantList =
          variants.where((v) => v.typeId == variantType.id).toList();
      return ProductVariant(variantType, variantList);
    }).toList();
  }
}

// Keep the original remote datasource for reference
class ProductDetailRemoteDatasource extends IProductDetailDatasource {
  final Dio _dio = locator.get();
  @override
  Future<List<ProductImageModel>> getGallery(String productId) async {
    try {
      Map<String, dynamic> qParams = {'filter': 'product_id="$productId"'};
      var response = await _dio.get('collections/gallery/records',
          queryParameters: qParams);
      return response.data['items']
          .map<ProductImageModel>(
              (jsonObject) => ProductImageModel.fromJson(jsonObject))
          .toList();
    } on DioException catch (ex) {
      throw ApiException(ex.response?.statusCode, ex.response?.data['message']);
    } catch (ex) {
      throw ApiException(0, 'unknown error');
    }
  }

  @override
  Future<List<VariantType>> getVariantTypes() async {
    try {
      var response = await _dio.get('collections/variants_type/records');
      return response.data['items']
          .map<VariantType>((jsonObject) => VariantType.fromJson(jsonObject))
          .toList();
    } on DioException catch (ex) {
      throw ApiException(ex.response?.statusCode, ex.response?.data['message']);
    } catch (ex) {
      throw ApiException(0, 'unknown error');
    }
  }

  @override
  Future<List<Variant>> getVariant(String productId) async {
    try {
      Map<String, String> qParams = {'filter': 'product_id="$productId"'};
      var response = await _dio.get('collections/variants/records',
          queryParameters: qParams);
      return response.data['items']
          .map<Variant>((jsonObject) => Variant.fromJson(jsonObject))
          .toList();
    } on DioException catch (ex) {
      throw ApiException(ex.response?.statusCode, ex.response?.data['message']);
    } catch (ex) {
      throw ApiException(0, 'unknown error');
    }
  }

  @override
  Future<List<ProductVariant>> getProductVariants(String productId) async {
    var variantTypeList = await getVariantTypes();
    var variantList = await getVariant(productId);

    List<ProductVariant> productVariantList = [];

    try {
      for (var variantType in variantTypeList) {
        var variant = variantList
            .where((element) => element.typeId == variantType.id)
            .toList();

        productVariantList.add(ProductVariant(variantType, variant));
      }
      return productVariantList;
    } on DioException catch (ex) {
      throw ApiException(ex.response?.statusCode, ex.response?.data['message']);
    } catch (e) {
      throw ApiException(0, 'unknown error');
    }
  }

  @override
  Future<CategoryModel> getProductCategory(String categoryId) async {
    try {
      Map<String, String> qParams = {'filter': 'id="$categoryId"'};
      var response = await _dio.get('collections/category/records',
          queryParameters: qParams);
      return CategoryModel.fromMapJson(response.data['items'][0]);
    } on DioException catch (ex) {
      throw ApiException(ex.response?.statusCode, ex.response?.data['message']);
    } catch (e) {
      throw ApiException(0, 'unknown error');
    }
  }

  @override
  Future<List<Property>> getProductProperties(String productId) async {
    try {
      Map<String, String> qParams = {'filter': 'id="$productId"'};
      var response = await _dio.get('collections/properties/records',
          queryParameters: qParams);
      return response.data['items']
          .map<Property>((jsonObject) => Property.fromJson(jsonObject))
          .toList();
    } on DioException catch (ex) {
      throw ApiException(ex.response?.statusCode, ex.response?.data['message']);
    } catch (e) {
      throw ApiException(0, '$e');
    }
  }
}
