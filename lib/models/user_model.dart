class UserModel {
  String name, email, phone, address;

  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? 'User',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
    );
  }
}
