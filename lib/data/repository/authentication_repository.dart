import 'package:dartz/dartz.dart';
import 'package:ecommerce/data/datasource/authentication_datasource.dart';
import 'package:ecommerce/di/di.dart';
import 'package:ecommerce/util/api_exception.dart';
import 'package:ecommerce/util/auth_manager.dart';

abstract class IAuthRepository {
  Future<Either<String, String>> register(
      String username, String password, String passwordConfirm);

  Future<Either<String, String>> login(String username, String password);
}

class AuthenticationRepository extends IAuthRepository {
  final IAuthenticationDatasource _datasource = locator.get();
  @override
  Future<Either<String, String>> register(
      String username, String password, String passwordConfirm) async {
    try {
      await _datasource.register(username, password, passwordConfirm);
      return right('Registration completed successfully!');
    } on ApiException catch (ex) {
      return left(ex.message ?? 'No error message available');
    }
  }

  @override
  Future<Either<String, String>> login(String username, String password) async {
    try {
      String token = await _datasource.login(username, password);
      if (token.isNotEmpty) {
        AuthManager.saveToken(token);
        return right('Login successful! Welcome back.');
      } else {
        return left('Error: Invalid token received');
      }
    } on ApiException catch (ex) {
      return left(ex.message ?? 'Login failed');
    } catch (e) {
      return left('Unknown error: $e');
    }
  }
}
