class UserModel {
  final String userName;
  final String email;
  final String phone;

  const UserModel({
    required this.userName,
    required this.email,
    required this.phone,
  });

  Map<String, dynamic> toMap() {
    return {
      "userName": userName,
      "email": email,
      "phone": phone,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userName: json["username"],
      email: json["email"],
      phone: json["phone"]??"",
    );
  }
//
}

