import 'package:dio/dio.dart';

import '../../domain/repositories/authentication_repository.dart';


class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final Dio dio;

  AuthenticationRepositoryImpl({required this.dio});

  @override
  Future<Map<String, dynamic>> register({
    required String dialCode,
    required String firstName,
    required String lastName,
    required String phone,
    required String identity,
    
  }) async {
    try {
      final response = await dio.post(
        'https://umlcc.chd-staging.tech/api/c/app/auth/register',
        options: Options(
          headers: 
          {
            "X-DID":identity,
            "Accept": "application/json"
          }),
        data: {
          'dial_code': dialCode,
          'first_name': firstName,
          'last_name': lastName,
          'identity': identity,
          'phone': phone,
          'type': 'individual'
        },
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to register user: $e');
    }
  }
  


  @override
Future<Map<String, dynamic>> login({
    required String dialCode,
    required String phone,
    required String identity,
  }) async {
    try {
      final response = await dio.post(
        'https://umlcc.chd-staging.tech/api/c/app/auth/login',
         options: Options(
          headers: 
          {
            "X-DID":identity,
            "Accept": "application/json"
          }),
        data: {
          'dial_code': dialCode,
          'phone': phone,
          'identity': identity,
        },
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }
}




class VerificationRepositoryImpl implements VerificationRepository {
  final Dio dio;

  VerificationRepositoryImpl({required this.dio});

  @override
  Future<Map<String, dynamic>> verify({
    required String fcmToken,
    required String identity,
    required String otp,
    required String dialCode,
    required String phone,
  }) async {
    try {
      final response = await dio.post(
        'https://umlcc.chd-staging.tech/api/c/app/auth/verify',
        options: Options(
          headers: 
          {
            "X-DID":identity,
            "Accept": "application/json"
          }),
        data: {
          'fcm_token': fcmToken,
          'identity': identity,
          'otp': otp,
          'dial_code': dialCode,
          'phone': phone,
        },
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to verify: $e');
    }
  }
}

/*class VerificationRepositoryImpl implements VerificationRepository {
  final Dio dio;

  VerificationRepositoryImpl({required this.dio});

  @override
  Future<Map<String, dynamic>> verify({required String identity, required int otp}) async {
    try {
      final response = await dio.post(
        'https://umlcc.chd-staging.tech/api/c/app/auth/verify',
        options: Options(
          headers: 
          {
            "X-DID":identity,
            "Accept": "application/json"
          }),
        data: {
          "fcm_token": "fsdfdsf",
          'identity': identity,
          'otp': otp,
        },
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to verify: $e');
    }
  }
}*/
