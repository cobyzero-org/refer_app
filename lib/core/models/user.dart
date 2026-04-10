class User {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final int stars;
  final bool keepUpdated;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.stars = 0,
    this.keepUpdated = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      photoUrl: json['photoUrl'],
      stars: json['stars'] ?? 0,
      keepUpdated: json['keepUpdated'] ?? false,
    );
  }
}
