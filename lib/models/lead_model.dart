class LeadModel {
  final String? id;
  final String name;
  final String email;
  final String phone;
  final String? imageUrl;

  LeadModel({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.imageUrl,
  });

  Map<String, String> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
    };
  }

  factory LeadModel.fromJson(Map<String, dynamic> json) {
    return LeadModel(
      id: json['id']?.toString(),
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      imageUrl: json['picture'],
    );
  }
}
