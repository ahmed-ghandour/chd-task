import '../../domain/entities/user_entity.dart';

class UserModel {
  final String identity;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  
  UserModel({
    required this.identity,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      identity: json['identity'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phoneNumber: json['phoneNumber'],
    );
  }
  User toEntity() {
    return User(
      type: "individual",
      identity: identity,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
    );
  }
  
}
