import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:refer_app/l10n/app_localizations.dart';
import '../../../core/theme.dart';
import '../../../core/bloc/locale_cubit.dart';
import '../../home/bloc/home_bloc.dart';
import '../../home/bloc/home_state.dart';
import '../../../core/di.dart';
import '../../splash/repository/app_config_repository.dart';
import '../../auth/repository/auth_repository.dart';
import '../../cart/bloc/cart_bloc.dart';
import '../../cart/bloc/cart_event.dart';
import '../../cart/bloc/locations_bloc.dart';
import '../../cart/bloc/locations_event.dart';
import '../../home/bloc/home_event.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.settings,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileCard(l10n),
            const SizedBox(height: 32),
            _buildSectionHeader(l10n.account),
            _buildSettingsItem(
              icon: Icons.person_outline_rounded,
              title: l10n.personalInfo,
              onTap: () => context.push('/edit-profile'),
            ),
            const SizedBox(height: 32),
            _buildSectionHeader(l10n.preferences),
            _buildSettingsItem(
              icon: Icons.history_rounded,
              title: l10n.orderHistory,
              onTap: () => context.push('/order-history'),
            ),
            _buildSettingsItem(
              icon: Icons.translate_rounded,
              title: l10n.language,
              onTap: () => _showLanguageSelector(context, l10n),
              trailing: Text(
                Localizations.localeOf(context).languageCode == 'es'
                    ? l10n.spanish
                    : l10n.english,
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 32),
            _buildSectionHeader(l10n.security),
            _buildSettingsItem(
              icon: Icons.lock_outline_rounded,
              title: l10n.changePassword,
              onTap: () => context.push('/change-password'),
            ),
            const SizedBox(height: 32),
            _buildSectionHeader(l10n.supportLegal),
            _buildSettingsItem(
              icon: Icons.help_outline_rounded,
              title: l10n.helpCenter,
              onTap: () {},
            ),
            _buildSettingsItem(
              icon: Icons.gavel_outlined,
              title: l10n.termsOfService,
              onTap: () {},
            ),
            _buildSettingsItem(
              icon: Icons.privacy_tip_outlined,
              title: l10n.privacyPolicy,
              onTap: () {},
            ),
            const SizedBox(height: 48),
            _buildSignOutButton(l10n),
            const SizedBox(height: 32),
            _buildVersionInfo(l10n),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  void _showLanguageSelector(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.language,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(l10n.english),
                trailing: Localizations.localeOf(context).languageCode == 'en'
                    ? const Icon(Icons.check_circle, color: AppColors.primary)
                    : null,
                onTap: () {
                  context.read<LocaleCubit>().changeLocale(const Locale('en'));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(l10n.spanish),
                trailing: Localizations.localeOf(context).languageCode == 'es'
                    ? const Icon(Icons.check_circle, color: AppColors.primary)
                    : null,
                onTap: () {
                  context.read<LocaleCubit>().changeLocale(const Locale('es'));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileCard(AppLocalizations l10n) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        String name = "Guest";
        String? photoUrl;
        int stars = 0;
        if (state is HomeLoaded) {
          name = state.user.name;
          photoUrl = state.user.photoUrl;
          stars = state.summary.stars;
        }

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundImage: NetworkImage(
                  photoUrl ?? 'https://i.pravatar.cc/150?u=fallback',
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Color(0xFFD4B16A),
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$stars ${l10n.stars}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: Colors.grey.shade500,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        leading: Icon(icon, color: AppColors.primary, size: 24),
        title: Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        trailing:
            trailing ??
            Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
      ),
    );
  }

  Widget _buildSignOutButton(AppLocalizations l10n) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          sl<AuthRepository>().logout();

          // Clear cached state for singletons
          context.read<HomeBloc>().add(HomeResetRequested());
          context.read<CartBloc>().add(CartCleared());
          context.read<LocationsBloc>().add(LocationsResetRequested());

          context.go('/auth');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.shade200,
          foregroundColor: Colors.red.shade700,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout_rounded, size: 20),
            const SizedBox(width: 12),
            Text(
              l10n.signOut,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVersionInfo(AppLocalizations l10n) {
    final version = sl<AppConfigRepository>().cachedConfig?.version ?? '0.0.0';
    return Center(
      child: Text(
        '${l10n.version} $version — Abal Organization',
        style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
      ),
    );
  }
}
