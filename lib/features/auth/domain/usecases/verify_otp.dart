import 'package:dartz/dartz.dart';
import 'package:kamulog_superapp/core/error/failures.dart';
import 'package:kamulog_superapp/core/usecase/usecase.dart';
import 'package:kamulog_superapp/features/auth/domain/entities/user.dart';
import 'package:kamulog_superapp/features/auth/domain/repositories/auth_repository.dart';

class VerifyOtpUseCase extends UseCase<User, VerifyOtpParams> {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(VerifyOtpParams params) async {
    return await repository.verifyOtp(phone: params.phone, code: params.code);
  }
}

class VerifyOtpParams {
  final String phone;
  final String code;
  const VerifyOtpParams({required this.phone, required this.code});
}
