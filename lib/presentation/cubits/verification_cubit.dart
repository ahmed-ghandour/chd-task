import '../../domain/use_cases/verify_code_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



abstract class VerificationState {}

class VerificationInitial extends VerificationState {}

class VerificationLoading extends VerificationState {}

class VerificationSuccess extends VerificationState {
  final String message;
  final String accessToken;
  final String tokenType;
  final int status;

  VerificationSuccess({
    required this.message,
    required this.accessToken,
    required this.tokenType,
    required this.status,
  });
}

class VerificationError extends VerificationState {
  final String message;

  VerificationError({required this.message});
}





class VerificationCubit extends Cubit<VerificationState> {
  final VerifyUseCase verifyUseCase;

  VerificationCubit(this.verifyUseCase) : super(VerificationInitial());

  Future<void> verify({
    required String fcmToken,
    required String identity,
    required String otp,
    required String dialCode,
    required String phone,
  }) async {
    emit(VerificationLoading());
    try {
      final response = await verifyUseCase(
        fcmToken: fcmToken,
        identity: identity,
        otp: otp,
        dialCode: dialCode,
        phone: phone,
      );

      final message = response['message'];
      final accessToken = response['access_token'];
      final tokenType = response['token_type'];
      final status = response['status'];

      emit(VerificationSuccess(
        message: message,
        accessToken: accessToken,
        tokenType: tokenType,
        status: status,
      ));
    } catch (e) {
      emit(VerificationError(message: 'Failed to verify: $e'));
    }
  }
}


/*class VerificationCubit extends Cubit<VerificationState> {
  final VerifyUseCase verifyUseCase;

  VerificationCubit(this.verifyUseCase) : super(VerificationInitial());

  Future<void> verify({required String identity, required int otp}) async {
    emit(VerificationLoading());
    try {
      final response = await verifyUseCase(identity: identity, otp: otp);

      final message = response['message'];
      final status = response['status'];

      emit(VerificationSuccess(message: message, status: status));
    } catch (e) {
      emit(VerificationError(message: 'Failed to verify: $e'));
    }
  }
}*/
