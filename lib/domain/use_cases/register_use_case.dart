

import '../repositories/authentication_repository.dart';

class RegisterUseCase {
  final AuthenticationRepository authenticationRepository;

  RegisterUseCase(this.authenticationRepository);

  Future<Map<String, dynamic>> call({
    required String dialCode,
    required String firstName,
    required String lastName,
    required String phone,
    required String identity,
    required String type,
  }) async {
    return await authenticationRepository.register(
      dialCode: dialCode.toString(),
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      identity: identity,
    );
  }
}
