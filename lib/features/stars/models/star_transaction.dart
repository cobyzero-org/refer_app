class StarTransaction {
  final String id;
  final String userId;
  final String type; // 'earn' or 'redeem'
  final String title;
  final int stars;
  final DateTime date;

  StarTransaction({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.stars,
    required this.date,
  });

  factory StarTransaction.fromJson(Map<String, dynamic> json) {
    return StarTransaction(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      type: json['type'] as String? ?? 'earn',
      title: json['title'] as String? ?? 'Activity',
      stars: (json['stars'] as num? ?? 0).toInt(),
      date: json['date'] != null 
          ? DateTime.parse(json['date'] as String)
          : DateTime.now(),
    );
  }
}
