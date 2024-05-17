import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/use_cases/get_user_details_use_case.dart';
import '../cubits/user_cubit.dart';

class UserDetailsScreen extends StatelessWidget {
  const UserDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
      ),
      body: BlocProvider(
        create: (context) {
          final repository = UserRepositoryImpl(dio: Dio());
          final getUserDetailsUseCase = GetUserDetailsUseCase(repository);
          return UserCubit(getUserDetailsUseCase)..fetchUserDetails();
        },
        child: const UserDetailsView(),
      ),
    );
  }
}

class UserDetailsView extends StatelessWidget {
  const UserDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UserLoaded) {
          final user = state.user;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(user['profile_picture']),
                  radius: 50,
                ),
                const SizedBox(height: 16),
                Text('${user['first_name']} ${user['last_name']}', style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 8),
                Text(user['email']),
                const SizedBox(height: 8),
                Text(user['phone']),
              ],
            ),
          );
        } else if (state is UserError) {
          return Center(child: Text(state.message));
        } else {
          return const Center(child: Text('Unknown state'));
        }
      },
    );
  }
}
