class DashboardSummary {
  final int stars;
  final List<ActivityItem> recentActivity;
  final List<RewardItem> rewards;
  final double nextRewardProgress;
  final Map<String, dynamic>? user;

  DashboardSummary({
    required this.stars,
    required this.recentActivity,
    required this.rewards,
    required this.nextRewardProgress,
    this.user,
  });

  factory DashboardSummary.fromJson(Map<String, dynamic> json) {
    return DashboardSummary(
      stars: json['stars'] ?? 0,
      recentActivity: (json['recentActivity'] as List? ?? [])
          .map((i) => ActivityItem.fromJson(i))
          .toList(),
      rewards: (json['rewards'] as List? ?? [])
          .map((i) => RewardItem.fromJson(i))
          .toList(),
      nextRewardProgress: (json['nextRewardProgress'] as num? ?? 0.0).toDouble(),
      user: json['user'],
    );
  }
}

class RewardItem {
  final String id;
  final String title;
  final int stars;
  final String? icon;

  RewardItem({
    required this.id,
    required this.title,
    required this.stars,
    this.icon,
  });

  factory RewardItem.fromJson(Map<String, dynamic> json) {
    return RewardItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      stars: json['stars'] ?? 0,
      icon: json['icon'],
    );
  }
}

class ActivityItem {
  final String id;
  final String type;
  final String title;
  final int stars;
  final DateTime date;

  ActivityItem({
    required this.id,
    required this.type,
    required this.title,
    required this.stars,
    required this.date,
  });

  factory ActivityItem.fromJson(Map<String, dynamic> json) {
    return ActivityItem(
      id: json['id'] ?? '',
      type: json['type'] ?? 'earn',
      title: json['title'] ?? '',
      stars: json['stars'] ?? 0,
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
    );
  }
}
