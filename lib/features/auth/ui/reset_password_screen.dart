import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:refer_app/l10n/app_localizations.dart';
import '../../../core/di.dart';
import '../../../core/theme.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'widgets/auth_input_field.dart';
import 'widgets/auth_header.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _code = TextEditingController();
  final _newPassword = TextEditingController();
  final _confirmNewPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (context) => sl<AuthBloc>(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primary),
            onPressed: () => context.pop(),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is ResetPasswordSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text("Password reset successfully. Please log in."),
                          backgroundColor: AppColors.primary,
                        ),
                      );
                      context.go('/auth');
                    }
                    if (state is AuthError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: Colors.red.shade800,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const AuthHeader(title: "Reset Password"),
                        const SizedBox(height: 24),
                        Text(
                          "Enter the 6-digit recovery code sent to ${widget.email} and choose your new password.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 32),
                        AuthInputField(
                          label: "Verification Code",
                          hint: "Enter 6-digit code",
                          controller: _code,
                        ),
                        const SizedBox(height: 24),
                        AuthInputField(
                          label: l10n.newPassword,
                          hint: l10n.passwordHint,
                          controller: _newPassword,
                          isPassword: true,
                        ),
                        const SizedBox(height: 24),
                        AuthInputField(
                          label: l10n.confirmPassword,
                          hint: l10n.passwordHint,
                          controller: _confirmNewPassword,
                          isPassword: true,
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: state is AuthLoading
                              ? null
                              : () {
                                  if (_newPassword.text != _confirmNewPassword.text) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(l10n.passwordsDoNotMatch),
                                        backgroundColor: Colors.red.shade800,
                                      ),
                                    );
                                    return;
                                  }
                                  context.read<AuthBloc>().add(
                                        ResetPasswordRequested(
                                          widget.email,
                                          _code.text,
                                          _newPassword.text,
                                        ),
                                      );
                                },
                          child: state is AuthLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Reset Password"),
                                    SizedBox(width: 10),
                                    Icon(Icons.lock_reset_rounded, size: 18),
                                  ],
                                ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
