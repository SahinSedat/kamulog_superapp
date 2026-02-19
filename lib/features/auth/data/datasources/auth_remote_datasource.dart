import 'package:firebase_auth/firebase_auth.dart';
import 'package:kamulog_superapp/core/error/exceptions.dart';
import 'package:kamulog_superapp/features/auth/data/models/user_model.dart';
// Note: ApiClient might still be used for backend syncing if needed, but primary auth is Firebase now.
// For now we will focus on Firebase Auth.

abstract class AuthRemoteDataSource {
  Future<void> signInWithPhone({
    required String phone,
    required Function(String, int?) onCodeSent,
    required Function(String) onVerificationFailed,
  });

  Future<UserModel> verifyOtp({
    required String verificationId,
    required String smsCode,
  });

  Future<void> signOut();

  Future<UserModel?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;

  AuthRemoteDataSourceImpl({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<void> signInWithPhone({
    required String phone,
    required Function(String, int?) onCodeSent,
    required Function(String) onVerificationFailed,
  }) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-retrieval or instant verification (Android only usually)
          // For consistency, we might just sign in here or let the user enter code.
          // We will sign in automatically if this triggers.
          await _firebaseAuth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          onVerificationFailed(e.message ?? 'Doğrulama hatası');
        },
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent(verificationId, resendToken);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-resolution timed out
        },
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      final user = userCredential.user;

      if (user == null) {
        throw const ServerException(message: 'Kullanıcı doğrulanamadı.');
      }

      // Map Firebase User to UserModel
      // Note: Firebase User doesn't have custom fields like employmentType yet.
      // We return a basic user model here.
      return UserModel(
        id: user.uid,
        phone: user.phoneNumber ?? '',
        // Other fields will be null initially or fetched from backend later
      );
    } on FirebaseAuthException catch (e) {
      throw ServerException(message: e.message ?? 'Doğrulama hatası');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      return UserModel(id: user.uid, phone: user.phoneNumber ?? '');
    }
    return null;
  }
}
