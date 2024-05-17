import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import '../../data/repositories/authentication_repository_impl.dart';
import '../../domain/use_cases/verify_code_use_case.dart';
import '../cubits/verification_cubit.dart';

class VerificationScreen extends StatelessWidget {
  final String fcmToken;
  final String identity;
  final String dialCode;
  final String phone;

  const VerificationScreen({super.key, 
    required this.fcmToken,
    required this.identity,
    required this.dialCode,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification'),
      ),
      body: BlocProvider(
        create: (context) {
          final repository = VerificationRepositoryImpl(dio: Dio());
          final verifyUseCase = VerifyUseCase(repository);
          return VerificationCubit(verifyUseCase);
        },
        child: VerificationForm(
          fcmToken: fcmToken,
          identity: identity,
          dialCode: dialCode,
          phone: phone,
        ),
      ),
    );
  }
}

class VerificationForm extends StatelessWidget {
  final String fcmToken;
  final String identity;
  final String dialCode;
  final String phone;
  final _otpController = TextEditingController();

  VerificationForm({super.key, 
    required this.fcmToken,
    required this.identity,
    required this.dialCode,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VerificationCubit, VerificationState>(
      listener: (context, state) {
        if (state is VerificationSuccess) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Verification Successful'),
              content: Text(state.message),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else if (state is VerificationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is VerificationLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'OTP'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    final otp = _otpController.text;
                    if (otp.isNotEmpty) {
                      BlocProvider.of<VerificationCubit>(context).verify(
                        fcmToken: fcmToken,
                        identity: identity,
                        otp: otp,
                        dialCode: dialCode,
                        phone: phone,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Invalid OTP')),
                      );
                    }
                  },
                  child: const Text('Verify'),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
