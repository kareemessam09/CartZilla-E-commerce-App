import 'package:dio/dio.dart';
import 'package:ecommerce/data/model/banner_model.dart';
import 'package:ecommerce/di/di.dart';
import 'package:ecommerce/util/api_exception.dart';

abstract class IBannerDataSource {
  Future<List<BannerModel>> getBanners();
}

class BannerLocalDataSource extends IBannerDataSource {
  // Sample banner data - You can modify this data as needed
  static final List<BannerModel> _sampleBanners = [
    BannerModel(
      'banner2',
      'banners',
      'https://images.unsplash.com/photo-1611078489935-0cb964de46d6?q=80&w=1074&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'laptops',
    ),
    BannerModel(
      'banner1',
      'banners',
      'https://images.unsplash.com/photo-1583573636246-18cb2246697f?q=80&w=1338&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'smartphones',
    ),
    BannerModel(
      'banner3',
      'banners',
      'https://images.unsplash.com/photo-1595793550800-5bdd9d23b2fa?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'cameras',
    ),
    BannerModel(
      'banner4',
      'banners',
      'https://images.unsplash.com/photo-1484704849700-f032a568e944?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'audio',
    ),
  ];

  @override
  Future<List<BannerModel>> getBanners() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_sampleBanners);
  }
}

// Keep the original remote datasource for reference
class BannerRemoteDataSource extends IBannerDataSource {
  Dio _dio = locator.get();
  @override
  Future<List<BannerModel>> getBanners() async {
    try {
      var response = await _dio.get('collections/banner/records');
      return response.data['items']
          .map<BannerModel>((jsonObject) => BannerModel.fromJson(jsonObject))
          .toList();
    } on DioException catch (ex) {
      throw ApiException(ex.response?.statusCode, ex.response?.data['message']);
    } catch (ex) {
      throw ApiException(0, 'unknown error');
    }
  }
}
