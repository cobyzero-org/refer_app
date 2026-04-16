import 'package:equatable/equatable.dart';

class Reward extends Equatable {
  final String id;
  final String title;
  final String description;
  final int starsRequired;
  final String? imageUrl;
  final String? icon;
  final bool isActive;

  const Reward({
    required this.id,
    required this.title,
    required this.description,
    required this.starsRequired,
    this.imageUrl,
    this.icon,
    this.isActive = true,
  });

  factory Reward.fromJson(Map<String, dynamic> json) {
    return Reward(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      starsRequired: json['starsRequired'],
      imageUrl: json['imageUrl'],
      icon: json['icon'],
      isActive: json['isActive'] ?? true,
    );
  }

  @override
  List<Object?> get props => [id, title, description, starsRequired, imageUrl, icon, isActive];
}
