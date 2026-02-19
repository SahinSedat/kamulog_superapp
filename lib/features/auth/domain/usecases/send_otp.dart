import 'package:fpdart/fpdart.dart';
import 'package:kamulog_superapp/core/error/failures.dart';
import 'package:kamulog_superapp/core/usecase/usecase.dart';
import 'package:kamulog_superapp/features/auth/domain/repositories/auth_repository.dart';

class SendOtpUseCase extends UseCase<void, SendOtpParams> {
  final AuthRepository repository;

  SendOtpUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SendOtpParams params) async {
    return await repository.signInWithPhone(
      phone: params.phone,
      onCodeSent: params.onCodeSent,
      onVerificationFailed: params.onVerificationFailed,
    );
  }
}

class SendOtpParams {
  final String phone;
  final Function(String, int?) onCodeSent;
  final Function(String) onVerificationFailed;

  const SendOtpParams({
    required this.phone,
    required this.onCodeSent,
    required this.onVerificationFailed,
  });
}
