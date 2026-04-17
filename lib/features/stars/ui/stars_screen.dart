import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:refer_app/features/stars/widgets/balance_card.dart';
import 'package:refer_app/features/stars/widgets/reward_redeem_card.dart';
import 'package:refer_app/l10n/app_localizations.dart';
import '../../../core/di.dart';
import '../bloc/stars_bloc.dart';
import '../bloc/stars_event.dart';
import '../bloc/stars_state.dart';
import '../models/reward.dart';
import '../models/perk.dart';

class StarsScreen extends StatelessWidget {
  const StarsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<StarsBloc>()..add(StarsStarted()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.starsRewards,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<StarsBloc, StarsState>(
          builder: (context, state) {
            if (state is StarsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is StarsError) {
              return Center(child: Text(state.message));
            }

            if (state is StarsLoaded) {
              // Find the next reward the user is working towards
              final sortedRewards = List<Reward>.from(state.rewards)
                ..sort((a, b) => a.starsRequired.compareTo(b.starsRequired));

              final nextReward = sortedRewards.firstWhere(
                (r) => r.starsRequired > state.balance,
                orElse: () => sortedRewards.isNotEmpty
                    ? sortedRewards.last
                    : Reward(
                        id: '',
                        description: '',
                        title: 'Max Level',
                        starsRequired: 1000,
                        imageUrl: '',
                      ),
              );

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BalanceCard(
                      stars: state.balance,
                      nextRewardStars: nextReward.starsRequired,
                      nextRewardName: nextReward.title,
                    ),
                    const SizedBox(height: 48),

                    // UNCLAIMED REWARDS SECTION
                    if (state.redeemedRewards.any((r) => !r.isClaimed)) ...[
                      const Text(
                        "Your Unclaimed Rewards",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...state.redeemedRewards.where((r) => !r.isClaimed).map((
                        r,
                      ) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: InkWell(
                            onTap: () {
                              final reward = state.rewards.firstWhere(
                                (rw) => rw.id == r.rewardId,
                                orElse: () => state.rewards.first,
                              );
                              context.push(
                                '/checkout',
                                extra: {
                                  'redeemedRewardId': r.id,
                                  'redeemedRewardTitle': r.rewardTitle,
                                  'redeemedRewardImage': reward.imageUrl,
                                },
                                );
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFFD4E9E2),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.02),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFFD4E9E2,
                                      ).withOpacity(0.5),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.star_rounded,
                                      color: Color(0xFF1E3932),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          r.rewardTitle,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Tap to claim",
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.chevron_right,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 32),
                    ],

                    Text(
                      AppLocalizations.of(context)!.redeemYourStars,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 24),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 1.1,
                          ),
                      itemCount: state.rewards.length,
                      itemBuilder: (context, index) {
                        final reward = state.rewards[index];
                        final hasEnoughStars =
                            state.balance >= reward.starsRequired;
                        return RewardRedeemCard(
                          reward: reward,
                          isDark:
                              index ==
                              2, // Just for visual variety matching original
                          onTap: () {
                            if (!hasEnoughStars) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.insufficientStars,
                                  ),
                                  backgroundColor: Colors.red.shade800,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                              return;
                            }
                            _showRedeemConfirmation(context, reward);
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 48),
                    Text(
                      AppLocalizations.of(context)!.earningPerks,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (state.perks.isEmpty)
                      const Center(
                        child: Text("Stay tuned for upcoming perks!"),
                      )
                    else ...[
                      // First perk as featured if exists
                      if (state.perks.isNotEmpty)
                        _buildFeaturedPerk(state.perks.first),
                      const SizedBox(height: 16),
                      // Others as simple perks
                      ...state.perks
                          .skip(1)
                          .map(
                            (perk) => Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: _buildSimplePerk(
                                icon: _getIconForPerk(perk.id),
                                title: perk.title,
                                description: perk.description,
                              ),
                            ),
                          ),
                    ],
                    const SizedBox(height: 48),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Recent Activity",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text("View History"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (state.history.isEmpty)
                      const Center(
                        child: Text(
                          "No recent activity",
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.history.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 32),
                        itemBuilder: (context, index) {
                          final activity = state.history[index];
                          final isEarn = activity.type == 'earn';
                          return _buildActivityItem(
                            title: activity.title,
                            subtitle:
                                "${activity.date.day}/${activity.date.month}/${activity.date.year}",
                            stars:
                                "${isEarn ? '+' : ''}${activity.stars} Stars",
                          );
                        },
                      ),
                    const SizedBox(height: 120),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Future<void> _showRedeemConfirmation(
    BuildContext context,
    Reward reward,
  ) async {
    return showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: Text(
          AppLocalizations.of(context)!.redeemReward,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: reward.imageUrl != null && reward.imageUrl!.isNotEmpty
                    ? Image.network(reward.imageUrl!, fit: BoxFit.cover)
                    : const Icon(
                        Icons.star_rounded,
                        size: 60,
                        color: Color(0xFF1E3932),
                      ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              reward.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(
                context,
              )!.confirmRedemption(reward.starsRequired),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              context.read<StarsBloc>().add(RedeemRewardRequested(reward.id));
              Navigator.pop(dialogContext);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Redeeming ${reward.title}..."),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E3932),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              elevation: 0,
            ),
            child: Text(
              AppLocalizations.of(context)!.confirm,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedPerk(Perk perk) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFD4E9E2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.star_rounded,
              color: Color(0xFF1E3932),
              size: 40,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  perk.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  perk.description,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimplePerk({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.black87, size: 28),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem({
    required String title,
    required String subtitle,
    required String stars,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.receipt_long_rounded,
            color: Colors.black54,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
            ],
          ),
        ),
        Text(
          stars,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
        ),
      ],
    );
  }

  IconData _getIconForPerk(String id) {
    switch (id) {
      case 'birthday':
        return Icons.celebration_rounded;
      case 'double-stars':
        return Icons.auto_awesome_rounded;
      case 'early-access':
        return Icons.history_edu_rounded;
      default:
        return Icons.star_outline_rounded;
    }
  }
}
