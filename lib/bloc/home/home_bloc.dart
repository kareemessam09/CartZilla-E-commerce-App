import 'package:ecommerce/bloc/home/home_event.dart';
import 'package:ecommerce/bloc/home/home_state.dart';
import 'package:ecommerce/data/repository/banner_repository.dart';
import 'package:ecommerce/data/repository/category_repository.dart';
import 'package:ecommerce/data/repository/product_repository.dart';
import 'package:ecommerce/di/di.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final IBannerRepository _bannerRepository = locator.get();
  final ICategoryRepository _categoryRepository = locator.get();
  final IProductRepository _productRepository = locator.get();

  HomeBloc() : super(HomeInitState()) {
    on<HomeGetInitializeEvent>((event, emit) async {
      emit(HomeLoadingState());
      var bannerList = await _bannerRepository.getBanners();
      var categoryList = await _categoryRepository.getCategories();
      var productList = await _productRepository.getProducts();
      var hottestProductList = await _productRepository.getHottest();
      var bestSellerProductList = await _productRepository.getBestSeller();

      emit(HomeRequestSuccessState(bannerList, categoryList, productList,hottestProductList,bestSellerProductList));
    });

    // on<HomeGetHottestEvent>((event, emit) async {
    //   emit(HomeLoadingState());
    //   var hottestProductList = await _productRepository.getHottest();
    //   emit(HomeRequestHottestSuccessState(hottestProductList));
    // });

    // on<HomeGetBestSellerEvent>((event, emit) async {
    //   emit(HomeLoadingState());
    //   var bestSellerProductList = await _productRepository.getBestSeller();
    //   emit(HomeRequestBestSellerSuccessState(bestSellerProductList));
    // });
  }
}
