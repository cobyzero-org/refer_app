class RedeemedReward {
  final String id;
  final String rewardId;
  final String rewardTitle;
  final bool isClaimed;
  final String? orderId;
  final DateTime createdAt;

  RedeemedReward({
    required this.id,
    required this.rewardId,
    required this.rewardTitle,
    required this.isClaimed,
    this.orderId,
    required this.createdAt,
  });

  factory RedeemedReward.fromJson(Map<String, dynamic> json) {
    return RedeemedReward(
      id: json['id'] as String? ?? '',
      rewardId: json['rewardId'] as String? ?? '',
      rewardTitle: json['rewardTitle'] as String? ?? '',
      isClaimed: json['isClaimed'] as bool? ?? false,
      orderId: json['orderId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String? ?? DateTime.now().toIso8601String()),
    );
  }
}
