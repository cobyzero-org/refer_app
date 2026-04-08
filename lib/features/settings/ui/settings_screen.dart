import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _digitalCardEnabled = true;
  bool _biometricEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileCard(),
            const SizedBox(height: 32),
            _buildSectionHeader("ACCOUNT"),
            _buildSettingsItem(
              icon: Icons.person_outline_rounded,
              title: "Personal Information",
              onTap: () {},
            ),
            _buildSettingsItem(
              icon: Icons.payments_outlined,
              title: "Payment Methods",
              onTap: () {},
            ),
            _buildSettingsItem(
              icon: Icons.badge_outlined,
              title: "Digital Roast Card",
              trailing: _buildSwitch(
                value: _digitalCardEnabled,
                onChanged: (v) => setState(() => _digitalCardEnabled = v),
              ),
            ),
            const SizedBox(height: 32),
            _buildSectionHeader("PREFERENCES"),
            _buildSettingsItem(
              icon: Icons.history_rounded,
              title: "Order History",
              onTap: () {},
            ),
            _buildSettingsItem(
              icon: Icons.storefront_outlined,
              title: "Favorite Stores",
              onTap: () {},
            ),
            _buildSettingsItem(
              icon: Icons.notifications_none_rounded,
              title: "Notifications",
              onTap: () {},
            ),
            const SizedBox(height: 32),
            _buildSectionHeader("SECURITY"),
            _buildSettingsItem(
              icon: Icons.lock_outline_rounded,
              title: "Change Password",
              onTap: () {},
            ),
            _buildSettingsItem(
              icon: Icons.fingerprint_rounded,
              title: "Biometric Login",
              trailing: _buildSwitch(
                value: _biometricEnabled,
                onChanged: (v) => setState(() => _biometricEnabled = v),
              ),
            ),
            const SizedBox(height: 32),
            _buildSectionHeader("SUPPORT & LEGAL"),
            _buildSettingsItem(
              icon: Icons.help_outline_rounded,
              title: "Help Center",
              onTap: () {},
            ),
            _buildSettingsItem(
              icon: Icons.gavel_outlined,
              title: "Terms of Service",
              onTap: () {},
            ),
            _buildSettingsItem(
              icon: Icons.privacy_tip_outlined,
              title: "Privacy Policy",
              onTap: () {},
            ),
            const SizedBox(height: 48),
            _buildSignOutButton(),
            const SizedBox(height: 32),
            _buildVersionInfo(),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
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
          const CircleAvatar(
            radius: 35,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=elias'),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Elias Thorne",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "View Profile",
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                      ),
                      Icon(Icons.chevron_right_rounded, size: 16, color: Colors.grey.shade500),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
        trailing: trailing ?? Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
      ),
    );
  }

  Widget _buildSwitch({required bool value, required ValueChanged<bool> onChanged}) {
    return Switch(
      value: value,
      onChanged: onChanged,
      activeColor: const Color(0xFF1E3932),
      activeTrackColor: const Color(0xFFD4E9E2),
    );
  }

  Widget _buildSignOutButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () => context.go('/auth'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.shade200,
          foregroundColor: Colors.red.shade700,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.logout_rounded, size: 20),
            SizedBox(width: 12),
            Text(
              "Sign Out",
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVersionInfo() {
    return Center(
      child: Text(
        "Version 2.4.1 (659) — The Editorial Roast Inc.",
        style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
      ),
    );
  }
}
