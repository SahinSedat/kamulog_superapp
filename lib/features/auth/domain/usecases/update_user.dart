import 'package:fpdart/fpdart.dart';
import 'package:kamulog_superapp/core/error/failures.dart';
import 'package:kamulog_superapp/core/usecase/usecase.dart';
import 'package:kamulog_superapp/features/auth/domain/entities/user.dart';
import 'package:kamulog_superapp/features/auth/domain/repositories/auth_repository.dart';

class UpdateUserUseCase extends UseCase<User, User> {
  final AuthRepository repository;

  UpdateUserUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(User user) async {
    return await repository.updateUserProfile(user);
  }
}
