class Perk {
  final String id;
  final String title;
  final String description;
  final String status;
  final String? icon;

  Perk({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    this.icon,
  });

  factory Perk.fromJson(Map<String, dynamic> json) {
    return Perk(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      status: json['status'] as String? ?? 'active',
      icon: json['icon'] as String?,
    );
  }
}
