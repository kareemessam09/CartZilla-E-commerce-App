import 'package:dio/dio.dart';
import 'package:ecommerce/data/datasource/authentication_datasource.dart';
import 'package:ecommerce/data/datasource/banner_datasource.dart';
import 'package:ecommerce/data/datasource/category_datasource.dart';
import 'package:ecommerce/data/datasource/category_product_datasource.dart';
import 'package:ecommerce/data/datasource/product_datasource.dart';
import 'package:ecommerce/data/datasource/product_detail_datasource.dart';
import 'package:ecommerce/data/repository/authentication_repository.dart';
import 'package:ecommerce/data/repository/banner_repository.dart';
import 'package:ecommerce/data/repository/category_product_repository.dart';
import 'package:ecommerce/data/repository/category_repository.dart';
import 'package:ecommerce/data/repository/product_detail_repository.dart';
import 'package:ecommerce/data/repository/product_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

var locator = GetIt.instance;

Future<void> getItInit() async {
//components
  locator.registerSingleton<Dio>(
      Dio(BaseOptions(baseUrl: 'https://startflutter.ir/api/')));

  locator.registerSingleton<SharedPreferences>(
      await SharedPreferences.getInstance());
//datasources
  // Using local datasources with sample data
  locator
      .registerFactory<IAuthenticationDatasource>(() => AuthenticationRemote());

  // Using local datasources with sample data
  locator.registerFactory<ICategoryDataSource>(() => CategoryLocalDatasource());

  locator.registerFactory<IBannerDataSource>(() => BannerLocalDataSource());

  locator.registerFactory<IProductDataSource>(() => ProductLocalDatasource());

  // Using local datasources for all components
  locator.registerFactory<IProductDetailDatasource>(
      () => ProductDetailLocalDatasource());

  locator.registerFactory<ICategoryProductDataSource>(
      () => CategoryProductLocalDatasource());

//repositories
  locator.registerFactory<IAuthRepository>(() => AuthenticationRepository());

  locator.registerFactory<ICategoryRepository>(() => CategoryRepository());

  locator.registerFactory<IBannerRepository>(() => BannerRepository());

  locator.registerFactory<IProductRepository>(() => ProductRepository());

  locator.registerFactory<IProductDetailRepository>(
      () => ProductDetailRepository());

  locator.registerFactory<ICategoryProductRepository>(
      () => CategoryProductRepository());
}
