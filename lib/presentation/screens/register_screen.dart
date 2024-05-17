import 'package:chd_auth/core/core.dart';
import 'package:chd_auth/presentation/screens/home_products_screen.dart';
import 'package:chd_auth/presentation/screens/verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import '../../data/repositories/authentication_repository_impl.dart';
import '../../domain/use_cases/register_use_case.dart';
import '../cubits/register_cubit.dart';


class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: BlocProvider(
        create: (context) {
          final repository = AuthenticationRepositoryImpl(dio: Dio());
          final registerUseCase = RegisterUseCase(repository);
          return RegisterCubit(registerUseCase);
        },
        child: RegisterForm(),
      ),
    );
  }
}

class RegisterForm extends StatelessWidget {
  final _dialCodeController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();

  RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Registration Successful'),
              content: Text('Your OTP is: ${state.otp}'),
              actions: [
                TextButton(
                  onPressed: () 
                  {
                    navigateTo(context,   VerificationScreen(
                      identity: "should have DID ",
                      dialCode: _dialCodeController.text,
                      phone: _phoneController.text,
                      fcmToken: "",
                      ));
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else if (state is RegisterError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        if (state is RegisterLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(labelText: 'First Name'),
                ),
                TextField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(labelText: 'Last Name'),
                ),
                TextField(
                  controller: _dialCodeController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Dial Code'),
                ),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<RegisterCubit>(context).register(
                      dialCode: _dialCodeController.text,
                      firstName: _firstNameController.text,
                      lastName: _lastNameController.text,
                      phone: _phoneController.text,
                      identity: 'your-device-id', // Replace with actual device ID
                    );
                  },
                  child: const Text('Register'),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
