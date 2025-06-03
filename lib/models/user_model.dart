class UserModel {
  final String firstName;
  final String lastName;
  final String email;
  final String thumbnailUrl;
  final String phone;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.thumbnailUrl,
    required this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final name = json['name'] as Map<String, dynamic>;
    final picture = json['picture'] as Map<String, dynamic>;
    return UserModel(
      firstName: name['first'] as String,
      lastName: name['last'] as String,
      email: json['email'] as String,
      thumbnailUrl: picture['thumbnail'] as String,
      phone: json['phone'] as String,
    );
  }

  String get fullName => '$firstName $lastName';
}
