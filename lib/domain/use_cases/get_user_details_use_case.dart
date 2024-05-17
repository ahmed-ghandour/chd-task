import '../repositories/user_repository.dart';

class GetUserDetailsUseCase {
  final UserRepository userRepository;

  GetUserDetailsUseCase(this.userRepository);

  Future<Map<String, dynamic>> call() async {
    return await userRepository.getUserDetails();
  }
}