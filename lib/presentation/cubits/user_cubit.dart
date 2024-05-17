import 'package:bloc/bloc.dart';

import '../../domain/use_cases/get_user_details_use_case.dart';


abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final Map<String, dynamic> user;

  UserLoaded({required this.user});
}

class UserError extends UserState {
  final String message;

  UserError({required this.message});
}




class UserCubit extends Cubit<UserState> {
  final GetUserDetailsUseCase getUserDetailsUseCase;

  UserCubit(this.getUserDetailsUseCase) : super(UserInitial());

  Future<void> fetchUserDetails() async {
    emit(UserLoading());
    try {
      final response = await getUserDetailsUseCase();
      final user = response['data'];
      emit(UserLoaded(user: user));
    } catch (e) {
      emit(UserError(message: 'Failed to fetch user details: $e'));
    }
  }
}
