import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/use_cases/register_use_case.dart';


abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final String message;
  final int status;
  final int otp;

  RegisterSuccess({
    required this.message,
    required this.status,
    required this.otp,
  });
}
class RegisterError extends RegisterState{
  final String error;

  RegisterError({required this.error});
}

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUseCase registerUseCase;

  RegisterCubit(this.registerUseCase) : super(RegisterInitial());

  Future<void> register({
    required String dialCode,
    required String firstName,
    required String lastName,
    required String phone,
    required String identity,
  }) async {
    emit(RegisterLoading());
    try {
      final response = await registerUseCase(
        dialCode: dialCode,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        identity: identity,
        type: "individual",
      );

      final message = response['message'];
      final status = response['status'];
      final otp = response['otp'];
      emit(RegisterSuccess(message: message, status: status, otp: otp));
      
    } catch (e) {
      emit(RegisterError(error: 'Failed to register: $e'));
    }
  }
}
