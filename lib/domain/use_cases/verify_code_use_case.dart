



import '../repositories/authentication_repository.dart';

class VerifyUseCase {
  final VerificationRepository verificationRepository;

  VerifyUseCase(this.verificationRepository);

  Future<Map<String, dynamic>> call({
    required String fcmToken,
    required String identity,
    required String otp,
    required String dialCode,
    required String phone,
  }) async {
    return await verificationRepository.verify(
      fcmToken: fcmToken,
      identity: identity,
      otp: otp,
      dialCode: dialCode,
      phone: phone,
    );
  }
}

