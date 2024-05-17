
import '../entities/user_entity.dart';

abstract class AuthenticationRepository {
  Future<Map<String, dynamic>> register({
    required String dialCode,
    required String firstName,
    required String lastName,
    required String phone,
    required String identity
  });


  Future<Map<String, dynamic>> login({
    required String dialCode,
    required String phone,
    required String identity,
  });
}

abstract class VerificationRepository {
  Future<Map<String, dynamic>> verify({
    required String fcmToken,
    required String identity,
    required String otp,
    required String dialCode,
    required String phone,
  });
}
