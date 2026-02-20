import 'package:fpdart/fpdart.dart';
import 'package:kamulog_superapp/core/error/failures.dart';
import 'package:kamulog_superapp/features/e_ticaret/domain/entities/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts();
  Future<Either<Failure, Product>> getProductById(String id);
}
