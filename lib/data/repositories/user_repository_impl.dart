import 'package:dio/dio.dart';

import '../../domain/repositories/user_repository.dart';


class UserRepositoryImpl implements UserRepository {
  final Dio dio;

  UserRepositoryImpl({required this.dio});

  @override
  Future<Map<String, dynamic>> getUserDetails() async {
    try {
      final response = await dio.get(
        'https://umlcc.chd-staging.tech/api/c/app/account/me',
        options: Options(
          headers: {
            'X-DID': 'your_device_id',
            'Authorization': 'Bearer your_token'
          },
        ),
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to fetch user details: $e');
    }
  }
}
