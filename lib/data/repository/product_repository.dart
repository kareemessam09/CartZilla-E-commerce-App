import 'package:dartz/dartz.dart';
import 'package:ecommerce/data/datasource/product_datasource.dart';
import 'package:ecommerce/data/model/product_model.dart';
import 'package:ecommerce/di/di.dart';
import 'package:ecommerce/util/api_exception.dart';

abstract class IProductRepository {
  Future<Either<String, List<ProductModel>>> getProducts();
  Future<Either<String, List<ProductModel>>> getHottest();
  Future<Either<String, List<ProductModel>>> getBestSeller();
}

class ProductRepository extends IProductRepository {
  final IProductDataSource _dataSource = locator.get();
  @override
  Future<Either<String, List<ProductModel>>> getProducts() async {
    try {
      var response = await _dataSource.getProducts();
      return right(response);
    } on ApiException catch (ex) {
      return Left(ex.message ?? 'No error message available');
    }
  }

  @override
  Future<Either<String, List<ProductModel>>> getBestSeller() async {
    try {
      var response = await _dataSource.getBeastSeller();
      return right(response);
    } on ApiException catch (ex) {
      return Left(ex.message ?? 'No error message available');
    }
  }

  @override
  Future<Either<String, List<ProductModel>>> getHottest() async {
    try {
      var response = await _dataSource.getHottest();
      return right(response);
    } on ApiException catch (ex) {
      return Left(ex.message ?? 'No error message available');
    }
  }
}
