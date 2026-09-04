import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:refer_app/features/stars/widgets/balance_card.dart';
import 'package:refer_app/features/stars/widgets/reward_redeem_card.dart';
import 'package:refer_app/l10n/app_localizations.dart';
import '../../../core/di.dart';
import '../../../core/theme.dart';
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
      create: (_) => sl<StarsBloc>()..add(StarsStarted()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          surfaceTintColor: Colors.transparent,
          elevation: 0, scrolledUnderElevation: 0,
          title: Text(AppLocalizations.of(context)!.starsRewards, style: GoogleFonts.outfit(fontSize: 17, fontWeight: FontWeight.w600, color: AppColors.text, letterSpacing: -0.2)),
          centerTitle: true,
        ),
        body: BlocBuilder<StarsBloc, StarsState>(
          builder: (context, state) {
            final l10n = AppLocalizations.of(context)!;
            if (state is StarsLoading) return _buildStarsShimmer(context);
            if (state is StarsError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Icon(Icons.cloud_off_rounded, size: 40, color: AppColors.textTertiary),
                    const SizedBox(height: 12),
                    Text(state.message, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 16),
                    FilledButton(onPressed: () => context.read<StarsBloc>().add(StarsStarted()), child: const Text('Try again')),
                  ]),
                ),
              );
            }
            if (state is StarsLoaded) {
              final sortedRewards = List<Reward>.from(state.rewards)..sort((a, b) => a.starsRequired.compareTo(b.starsRequired));
              final nextReward = sortedRewards.firstWhere((r) => r.starsRequired > state.balance, orElse: () => sortedRewards.isNotEmpty ? sortedRewards.last : Reward(id: '', description: '', title: 'Max Level', starsRequired: 1000, imageUrl: ''));
              final bottomPadding = MediaQuery.of(context).padding.bottom + 88;

              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () async => context.read<StarsBloc>().add(StarsStarted()),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(20, 8, 20, bottomPadding),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    BalanceCard(stars: state.balance, nextRewardStars: nextReward.starsRequired, nextRewardName: nextReward.title),
                    const SizedBox(height: 28),
                    if (state.redeemedRewards.any((r) => !r.isClaimed)) ...[
                      _SectionHeader(title: l10n.unclaimedRewards),
                      const SizedBox(height: 12),
                      ...state.redeemedRewards.where((r) => !r.isClaimed).map((r) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Semantics(
                            button: true, label: r.rewardTitle, hint: 'Tap to claim at checkout',
                            child: InkWell(
                              onTap: () {
                                final reward = state.rewards.firstWhere((rw) => rw.id == r.rewardId, orElse: () => state.rewards.first);
                                context.push('/checkout', extra: {'redeemedRewardId': r.id, 'redeemedRewardTitle': r.rewardTitle, 'redeemedRewardImage': reward.imageUrl});
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.secondary), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 3))]),
                                child: Row(children: [
                                  Container(padding: const EdgeInsets.all(9), decoration: BoxDecoration(color: AppColors.secondary.withValues(alpha: 0.6), shape: BoxShape.circle), child: const Icon(Icons.star_rounded, color: AppColors.primary, size: 20)),
                                  const SizedBox(width: 14),
                                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Text(r.rewardTitle, style: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.text)),
                                    const SizedBox(height: 2),
                                    Text(l10n.tapToClaim, style: GoogleFonts.outfit(color: AppColors.textSecondary, fontSize: 12.5)),
                                  ])),
                                  const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary, size: 20),
                                ]),
                              ),
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 20),
                    ],
                    _SectionHeader(title: l10n.redeemYourStars),
                    const SizedBox(height: 12),
                    GridView.builder(
                      shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.05),
                      itemCount: state.rewards.length,
                      itemBuilder: (context, index) {
                        final reward = state.rewards[index];
                        final hasEnough = state.balance >= reward.starsRequired;
                        return RewardRedeemCard(
                          reward: reward,
                          isDark: index == 2,
                          enabled: hasEnough,
                          onTap: () {
                            if (!hasEnough) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(l10n.insufficientStars),
                                backgroundColor: AppColors.text, behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), margin: const EdgeInsets.all(16),
                              ));
                              return;
                            }
                            _showRedeemConfirmation(context, reward);
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 28),
                    _SectionHeader(title: l10n.earningPerks),
                    const SizedBox(height: 12),
                    if (state.perks.isEmpty)
                      Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 28), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.separator)), child: Text(l10n.stayTunedPerks, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium))
                    else ...[
                      if (state.perks.isNotEmpty) _buildFeaturedPerk(state.perks.first),
                      const SizedBox(height: 12),
                      ...state.perks.skip(1).map((perk) => Padding(padding: const EdgeInsets.only(bottom: 12), child: _buildSimplePerk(icon: _getIconForPerk(perk.id), title: perk.title, description: perk.description))),
                    ],
                    const SizedBox(height: 28),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Semantics(header: true, child: Text(l10n.recentActivity, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.text, letterSpacing: -0.3))),
                      TextButton(onPressed: () => context.push('/stars-history', extra: context.read<StarsBloc>()), style: TextButton.styleFrom(minimumSize: const Size(44, 32)), child: Text(l10n.viewHistory)),
                    ]),
                    const SizedBox(height: 8),
                    if (state.history.isEmpty)
                      Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 24), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.separator)), child: Text(l10n.noRecentActivity, textAlign: TextAlign.center, style: GoogleFonts.outfit(color: AppColors.textSecondary, fontSize: 13)))
                    else
                      ListView.separated(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: state.history.length, separatorBuilder: (_, __) => const Divider(height: 24), itemBuilder: (context, index) {
                        final a = state.history[index];
                        final isEarn = a.type == 'earn';
                        return _buildActivityItem(title: a.title, subtitle: '${a.date.day}/${a.date.month}/${a.date.year}', stars: "${isEarn ? '+' : ''}${a.stars} Stars", isEarn: isEarn);
                      }),
                  ]),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Future<void> _showRedeemConfirmation(BuildContext context, Reward reward) async {
    final l10n = AppLocalizations.of(context)!;
    return showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l10n.redeemReward, style: GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 17, color: AppColors.text)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(height: 96, width: 96, decoration: BoxDecoration(color: AppColors.neutralGrouped, borderRadius: BorderRadius.circular(16)), child: ClipRRect(borderRadius: BorderRadius.circular(16), child: reward.imageUrl != null && reward.imageUrl!.isNotEmpty ? Image.network(reward.imageUrl!, fit: BoxFit.cover) : const Icon(Icons.star_rounded, size: 44, color: AppColors.primary))),
          const SizedBox(height: 16),
          Text(reward.title, textAlign: TextAlign.center, style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.text)),
          const SizedBox(height: 6),
          Text(l10n.confirmRedemption(reward.starsRequired), textAlign: TextAlign.center, style: GoogleFonts.outfit(color: AppColors.textSecondary, fontSize: 13, height: 1.4)),
        ]),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), style: TextButton.styleFrom(minimumSize: const Size(44, 44)), child: Text(l10n.cancel)),
          const SizedBox(width: 6),
          FilledButton(
            onPressed: () {
              context.read<StarsBloc>().add(RedeemRewardRequested(reward.id));
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(l10n.redeemingReward(reward.title)),
                backgroundColor: AppColors.text, behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), margin: const EdgeInsets.all(16),
              ));
            },
            style: FilledButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedPerk(Perk perk) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.separator)),
      child: Row(children: [
        Container(height: 64, width: 64, decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.star_rounded, color: AppColors.primary, size: 32)),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(perk.title, style: GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.text)),
          const SizedBox(height: 6),
          Text(perk.description, style: GoogleFonts.outfit(color: AppColors.textSecondary, fontSize: 12.5, height: 1.4)),
        ])),
      ]),
    );
  }

  Widget _buildSimplePerk({required IconData icon, required String title, required String description}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.separator)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(height: 36, width: 36, decoration: BoxDecoration(color: AppColors.neutralGrouped, borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: AppColors.text, size: 20)),
        const SizedBox(height: 12),
        Text(title, style: GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.text)),
        const SizedBox(height: 6),
        Text(description, style: GoogleFonts.outfit(color: AppColors.textSecondary, fontSize: 12.5, height: 1.4)),
      ]),
    );
  }

  Widget _buildActivityItem({required String title, required String subtitle, required String stars, required bool isEarn}) {
    return Row(children: [
      Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: isEarn ? AppColors.secondary.withValues(alpha: 0.6) : const Color(0xFFFEF3C7), shape: BoxShape.circle), child: Icon(isEarn ? Icons.add_rounded : Icons.remove_rounded, color: isEarn ? AppColors.primary : const Color(0xFF92400E), size: 18)),
      const SizedBox(width: 14),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.text)),
        const SizedBox(height: 2),
        Text(subtitle, style: GoogleFonts.outfit(color: AppColors.textTertiary, fontSize: 12)),
      ])),
      Text(stars, style: GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 13, color: isEarn ? AppColors.primary : AppColors.text)),
    ]);
  }

  IconData _getIconForPerk(String id) {
    switch (id) {
      case 'birthday': return Icons.celebration_rounded;
      case 'double-stars': return Icons.auto_awesome_rounded;
      case 'early-access': return Icons.history_edu_rounded;
      default: return Icons.star_outline_rounded;
    }
  }

  Widget _buildStarsShimmer(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Shimmer.fromColors(
        baseColor: AppColors.separator, highlightColor: Colors.white,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(width: double.infinity, height: 200, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16))),
          const SizedBox(height: 28),
          Container(width: 160, height: 18, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6))),
          const SizedBox(height: 12),
          GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: 4, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.05), itemBuilder: (_, __) => Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)))),
        ]),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});
  @override
  Widget build(BuildContext context) => Semantics(header: true, child: Text(title, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.text, letterSpacing: -0.3)));
}
