import 'package:dartz/dartz.dart';
import 'package:kamulog_superapp/core/error/failures.dart';

/// Base use case with parameters
abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// Use case with no parameters
abstract class UseCaseNoParams<T> {
  Future<Either<Failure, T>> call();
}

/// Empty params marker
class NoParams {
  const NoParams();
}
