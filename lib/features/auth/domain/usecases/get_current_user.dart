import 'package:fpdart/fpdart.dart';
import 'package:kamulog_superapp/core/error/failures.dart';
import 'package:kamulog_superapp/core/usecase/usecase.dart';
import 'package:kamulog_superapp/features/auth/domain/entities/user.dart';
import 'package:kamulog_superapp/features/auth/domain/repositories/auth_repository.dart';

class GetCurrentUserUseCase extends UseCase<User, NoParams> {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await repository.getCurrentUser();
  }
}
