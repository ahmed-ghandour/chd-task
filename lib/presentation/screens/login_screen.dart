import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import '../../data/repositories/authentication_repository_impl.dart';
import '../../domain/use_cases/login_use_case.dart';
import '../cubits/login_cubit.dart';
import 'register_screen.dart'; // Import the register screen for navigation

class LoginScreen extends StatelessWidget {
  final _dialCodeController = TextEditingController(text: '+20'); // Default value
  final _phoneController = TextEditingController();
  final _identityController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: BlocProvider(
        create: (context) {
          final repository = AuthenticationRepositoryImpl(dio: Dio());
          final loginUseCase = LoginUseCase(repository);
          return LoginCubit(loginUseCase);
        },
        child: LoginForm(
          dialCodeController: _dialCodeController,
          phoneController: _phoneController,
          identityController: _identityController,
        ),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  final TextEditingController dialCodeController;
  final TextEditingController phoneController;
  final TextEditingController identityController;

  LoginForm({super.key, 
    required this.dialCodeController,
    required this.phoneController,
    required this.identityController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Login Successful'),
              content: Text(state.message),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else if (state is LoginError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is LoginLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: dialCodeController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Dial Code'),
                ),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                ),
                TextField(
                  controller: identityController,
                  decoration: const InputDecoration(labelText: 'Identity'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    final dialCode = dialCodeController.text;
                    final phone = phoneController.text;
                    final identity = identityController.text;
                    if (dialCode.isNotEmpty && phone.isNotEmpty && identity.isNotEmpty) {
                      BlocProvider.of<LoginCubit>(context).login(
                        dialCode: dialCode,
                        phone: phone,
                        identity: identity,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill all fields')),
                      );
                    }
                  },
                  child: const Text('Login'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterScreen()),
                    );
                  },
                  child: const Text('Don\'t have an account? Register'),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
