import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:refer_app/core/widgets/button_liquid_glass.dart';
import 'package:refer_app/features/home/bloc/home_event.dart';
import '../../../l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import '../../home/bloc/home_bloc.dart';
import '../../home/bloc/home_state.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _birthDateController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _birthDateController = TextEditingController();

    // Initializing with current user data if available
    final state = context.read<HomeBloc>().state;
    if (state is HomeLoaded) {
      _nameController.text = state.user.name;
      _emailController.text = state.user.email;
      _phoneController.text = state.user.phoneNumber ?? "";
      _birthDateController.text = state.user.birthDate ?? "";
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E3932)),
          onPressed: () => context.pop(),
        ),
        title: Text(
          l10n.editProfile,
          style: const TextStyle(
            color: Color(0xFF1E3932),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
      ),
      body: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeLoaded) {
            if (state.status == HomeStatus.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message ?? l10n.profileUpdated),
                  backgroundColor: const Color(0xFF1E3932),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
              context.pop();
            } else if (state.status == HomeStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message ?? l10n.errorUpdatingProfile),
                  backgroundColor: Colors.red.shade800,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            String? photoUrl;
            bool isLoading = false;
            if (state is HomeLoaded) {
              photoUrl = state.user.photoUrl;
              isLoading = state.status == HomeStatus.loading;
            }

            return Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 140),
                  child: Column(
                    children: [
                      _buildProfileImagePicker(photoUrl),
                      const SizedBox(height: 48),
                      _buildInputField(
                        label: l10n.fullName,
                        controller: _nameController,
                      ),
                      const SizedBox(height: 24),
                      _buildInputField(
                        label: l10n.emailAddress,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 24),
                      _buildInputField(
                        label: l10n.phoneNumber,
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 24),
                      _buildInputField(
                        label: l10n.birthDate,
                        controller: _birthDateController,
                        readOnly: true,
                        suffixIcon: Icons.calendar_today_outlined,
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now().subtract(
                              const Duration(days: 365 * 20),
                            ),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setState(() {
                              _birthDateController.text =
                                  "${picked.month}/${picked.day}/${picked.year}";
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: _buildBottomAction(isLoading),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileImagePicker(String? photoUrl) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final l10n = AppLocalizations.of(context)!;
        bool isUploading = false;
        if (state is HomeLoaded) {
          isUploading = state.status == HomeStatus.loading;
        }

        return Column(
          children: [
            InkWell(
              onTap: isUploading
                  ? null
                  : () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image = await picker.pickImage(
                        source: ImageSource.gallery,
                        imageQuality: 70,
                      );
                      if (image != null && context.mounted) {
                        context.read<HomeBloc>().add(
                          ProfileImageUpdated(image.path),
                        );
                      }
                    },
              borderRadius: BorderRadius.circular(60),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 56,
                          backgroundImage: NetworkImage(
                            photoUrl ?? 'https://i.pravatar.cc/150?u=fallback',
                          ),
                        ),
                        if (isUploading)
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1E3932),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.tapToUpdateImage,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    bool readOnly = false,
    IconData? suffixIcon,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          onTap: onTap,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3132),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFEFEFEF),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            suffixIcon: suffixIcon != null
                ? Icon(suffixIcon, color: Colors.grey.shade600, size: 20)
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomAction(bool isLoading) {
    final l10n = AppLocalizations.of(context)!;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ButtonLiquidGlass(
          onTap: isLoading
              ? () {}
              : () {
                  context.read<HomeBloc>().add(
                    UserProfileUpdated(
                      name: _nameController.text,
                      email: _emailController.text,
                      phoneNumber: _phoneController.text,
                      birthDate: _birthDateController.text,
                    ),
                  );
                },
          title: l10n.saveChanges,
          subTitle: '',
          icon: Icons.save,
        ),
      ),
    );
  }
}
