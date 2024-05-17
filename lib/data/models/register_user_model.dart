class RegisteredUserModel{
  String? message;
  String? status;
  String? otp;
  
  RegisteredUserModel({
    required this.message,
    required this.status,
    required this.otp
  });

  RegisteredUserModel.fromJson(Map<String,dynamic>json){
    message = json['message'];
    status = json['status'];
    otp = json['otp'];
  }

  RegisteredUserModel toEntity() {
    return RegisteredUserModel(
      message: message,
      status: status,
      otp: otp,
    );
  }
}