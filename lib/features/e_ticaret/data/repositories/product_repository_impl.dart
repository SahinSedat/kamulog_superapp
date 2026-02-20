import 'package:fpdart/fpdart.dart';
import 'package:kamulog_superapp/core/database/app_database.dart';
import 'package:kamulog_superapp/core/error/failures.dart';
import 'package:kamulog_superapp/features/e_ticaret/domain/entities/product.dart'
    as entity;
import 'package:kamulog_superapp/features/e_ticaret/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final AppDatabase database;

  ProductRepositoryImpl({required this.database});

  @override
  Future<Either<Failure, List<entity.Product>>> getProducts() async {
    try {
      final results = await database.getAllProducts();
      return Right(results.map(_toEntity).toList());
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, entity.Product>> getProductById(String id) async {
    try {
      final all = await database.getAllProducts();
      final found = all.firstWhere((p) => p.id == id);
      return Right(_toEntity(found));
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  entity.Product _toEntity(Product db) {
    return entity.Product(
      id: db.id,
      name: db.name,
      price: db.price,
      imageUrl: db.imageUrl,
      stock: db.stock,
      description: db.description,
      createdAt: db.createdAt,
    );
  }
}
