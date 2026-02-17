import 'package:dartz/dartz.dart';
import 'package:kamulog_superapp/core/error/failures.dart';
import 'package:kamulog_superapp/core/usecase/usecase.dart';
import 'package:kamulog_superapp/features/auth/domain/repositories/auth_repository.dart';

class SendOtpUseCase extends UseCase<bool, SendOtpParams> {
  final AuthRepository repository;

  SendOtpUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(SendOtpParams params) async {
    return await repository.sendOtp(phone: params.phone);
  }
}

class SendOtpParams {
  final String phone;
  const SendOtpParams({required this.phone});
}
