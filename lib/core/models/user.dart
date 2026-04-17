class User {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final int stars;
  final bool keepUpdated;
  final String? phoneNumber;
  final String? birthDate;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.stars = 0,
    this.keepUpdated = false,
    this.phoneNumber,
    this.birthDate,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      photoUrl: json['photoUrl'],
      stars: json['stars'] ?? 0,
      keepUpdated: json['keepUpdated'] == true || json['keepUpdated'] == 1 || json['keepUpdated'] == '1',
      phoneNumber: json['phoneNumber'],
      birthDate: json['birthDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'stars': stars,
      'keepUpdated': keepUpdated,
      'phoneNumber': phoneNumber,
      'birthDate': birthDate,
    };
  }
}
