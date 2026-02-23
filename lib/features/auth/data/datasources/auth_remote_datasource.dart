import 'package:firebase_auth/firebase_auth.dart';
import 'package:kamulog_superapp/core/error/exceptions.dart';
import 'package:kamulog_superapp/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<void> signInWithPhone({
    required String phone,
    required Function(String, int?) onCodeSent,
    required Function(String) onVerificationFailed,
  });

  Future<UserModel> verifyOtp({
    required String verificationId,
    required String smsCode,
    String? displayName,
  });

  Future<void> signOut();

  Future<UserModel?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  FirebaseAuth? _firebaseAuth;
  bool _isFirebaseAvailable = false;

  AuthRemoteDataSourceImpl({FirebaseAuth? firebaseAuth}) {
    try {
      _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;
      _isFirebaseAvailable = true;
    } catch (_) {
      // Firebase not initialized — dev mode
      _isFirebaseAvailable = false;
    }
  }

  @override
  Future<void> signInWithPhone({
    required String phone,
    required Function(String, int?) onCodeSent,
    required Function(String) onVerificationFailed,
  }) async {
    if (!_isFirebaseAvailable || _firebaseAuth == null) {
      // Dev mode: simulate OTP sent
      await Future.delayed(const Duration(seconds: 1));
      onCodeSent('dev-verification-id', null);
      return;
    }

    try {
      await _firebaseAuth!.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _firebaseAuth!.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          onVerificationFailed(e.message ?? 'Doğrulama hatası');
        },
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent(verificationId, resendToken);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> verifyOtp({
    required String verificationId,
    required String smsCode,
    String? displayName,
  }) async {
    if (!_isFirebaseAvailable || _firebaseAuth == null) {
      // Dev mode: simulate successful verification
      await Future.delayed(const Duration(seconds: 1));
      return UserModel(
        id: 'dev-user-001',
        phone: '+905551234567',
        name: displayName ?? 'Geliştirici',
      );
    }

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final userCredential = await _firebaseAuth!.signInWithCredential(
        credential,
      );
      final user = userCredential.user;

      if (user == null) {
        throw const ServerException(message: 'Kullanıcı doğrulanamadı.');
      }

      // Firebase'e displayName kaydet
      if (displayName != null && displayName.isNotEmpty) {
        await user.updateDisplayName(displayName);
      }

      return UserModel(
        id: user.uid,
        phone: user.phoneNumber ?? '',
        name: displayName ?? user.displayName,
      );
    } on FirebaseAuthException catch (e) {
      throw ServerException(message: e.message ?? 'Doğrulama hatası');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    if (_isFirebaseAvailable && _firebaseAuth != null) {
      await _firebaseAuth!.signOut();
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    if (!_isFirebaseAvailable || _firebaseAuth == null) {
      return null; // Dev mode: no persisted user from Firebase
    }
    final user = _firebaseAuth!.currentUser;
    if (user != null) {
      return UserModel(id: user.uid, phone: user.phoneNumber ?? '');
    }
    return null;
  }
}
