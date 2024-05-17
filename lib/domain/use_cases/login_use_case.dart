import '../repositories/authentication_repository.dart';

class LoginUseCase {
  final AuthenticationRepository authenticationRepository;

  LoginUseCase(this.authenticationRepository);

  Future<Map<String, dynamic>> call({
    required String dialCode,
    required String phone,
    required String identity,
  }) async {
    return await authenticationRepository.login(
      dialCode: dialCode,
      phone: phone,
      identity: identity,
    );
  }
}