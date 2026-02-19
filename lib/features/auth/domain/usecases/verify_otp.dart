import 'package:fpdart/fpdart.dart';
import 'package:kamulog_superapp/core/error/failures.dart';
import 'package:kamulog_superapp/core/usecase/usecase.dart';
import 'package:kamulog_superapp/features/auth/domain/entities/user.dart';
import 'package:kamulog_superapp/features/auth/domain/repositories/auth_repository.dart';

class VerifyOtpUseCase extends UseCase<User, VerifyOtpParams> {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(VerifyOtpParams params) async {
    return await repository.verifyOtp(
      verificationId: params.verificationId,
      smsCode: params.smsCode,
    );
  }
}

class VerifyOtpParams {
  final String verificationId;
  final String smsCode;

  const VerifyOtpParams({required this.verificationId, required this.smsCode});
}
