import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../core/theme.dart';
import '../bloc/stars_bloc.dart';
import '../bloc/stars_event.dart';
import '../bloc/stars_state.dart';

class StarsHistoryScreen extends StatelessWidget {
  const StarsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Center(
          child: Container(
            height: 38,
            width: 38,
            margin: const EdgeInsets.only(left: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade200, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              iconSize: 16,
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.primary,
              ),
              onPressed: () => context.pop(),
            ),
          ),
        ),
        title: Text(
          l10n.starsHistory,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
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
            final history = state.history;

            if (history.isEmpty) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<StarsBloc>().add(StarsStarted());
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history_rounded,
                          size: 64,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.noRecentActivity,
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<StarsBloc>().add(StarsStarted());
              },
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                itemCount: history.length,
                separatorBuilder: (context, index) => const Divider(height: 32),
                itemBuilder: (context, index) {
                  final activity = history[index];
                  final isEarn = activity.type == 'earn';
                  return Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isEarn
                              ? const Color(0xFFD4E9E2).withOpacity(0.5)
                              : Colors.amber.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isEarn ? Icons.add_circle_outline_rounded : Icons.remove_circle_outline_rounded,
                          color: isEarn ? const Color(0xFF1E3932) : Colors.amber.shade900,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              activity.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppColors.text,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${activity.date.day}/${activity.date.month}/${activity.date.year}',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${isEarn ? '+' : '-'}${activity.stars} Stars',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          color: isEarn ? const Color(0xFF1E3932) : Colors.amber.shade900,
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
