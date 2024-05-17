import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/use_cases/login_use_case.dart';




abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String message;
  final String accessToken;
  final String tokenType;
  final int status;

  LoginSuccess({
    required this.message,
    required this.accessToken,
    required this.tokenType,
    required this.status,
  });
}

class LoginError extends LoginState {
  final String message;

  LoginError({required this.message});
}



class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;

  LoginCubit(this.loginUseCase) : super(LoginInitial());

  Future<void> login({
    required String dialCode,
    required String phone,
    required String identity,
  }) async {
    emit(LoginLoading());
    try {
      final response = await loginUseCase(
        dialCode: dialCode,
        phone: phone,
        identity: identity,
      );

      final message = response['message'];
      final accessToken = response['access_token'];
      final tokenType = response['token_type'];
      final status = response['status'];

      emit(LoginSuccess(
        message: message,
        accessToken: accessToken,
        tokenType: tokenType,
        status: status,
      ));
    } catch (e) {
      emit(LoginError(message: 'Failed to login: $e'));
    }
  }
}
