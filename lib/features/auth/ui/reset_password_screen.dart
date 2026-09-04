import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  final _codeFocus = FocusNode();
  final _newPasswordFocus = FocusNode();
  final _confirmFocus = FocusNode();

  String? _codeError;
  String? _newPasswordError;
  String? _confirmError;

  @override
  void dispose() {
    _code.dispose();
    _newPassword.dispose();
    _confirmNewPassword.dispose();
    _codeFocus.dispose();
    _newPasswordFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  String _toSentenceCase(String input) {
    if (input == input.toUpperCase() && input.length <= 30) {
      return input[0].toUpperCase() + input.substring(1).toLowerCase();
    }
    return input;
  }

  void _submit(BuildContext blocContext, AppLocalizations l10n) {
    final code = _code.text.trim();
    final pwd = _newPassword.text;
    final confirm = _confirmNewPassword.text;

    setState(() {
      _codeError = code.length != 6 ? 'Enter the 6-digit code' : null;
      _newPasswordError = pwd.length < 6 ? 'Password must be at least 6 characters' : null;
      _confirmError = confirm != pwd ? l10n.passwordsDoNotMatch : null;
    });

    if ([_codeError, _newPasswordError, _confirmError].any((e) => e != null)) {
      HapticFeedback.selectionClick();
      return;
    }

    FocusScope.of(context).unfocus();
    TextInput.finishAutofillContext();
    blocContext.read<AuthBloc>().add(
          ResetPasswordRequested(widget.email, code, pwd),
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: AppColors.text),
            onPressed: () => context.pop(),
            tooltip: 'Back',
            style: IconButton.styleFrom(minimumSize: const Size(44, 44)),
          ),
        ),
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Center(
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is ResetPasswordSuccess) {
                        HapticFeedback.lightImpact();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Row(
                              children: [
                                Icon(Icons.check_circle_outline_rounded, color: Colors.white, size: 20),
                                SizedBox(width: 10),
                                Expanded(child: Text('Password reset successfully. Please log in.')),
                              ],
                            ),
                            backgroundColor: AppColors.text,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            margin: const EdgeInsets.all(16),
                          ),
                        );
                        context.go('/auth');
                      }
                      if (state is AuthError) {
                        HapticFeedback.heavyImpact();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(Icons.error_outline_rounded, color: Colors.white, size: 20),
                                const SizedBox(width: 10),
                                Expanded(child: Text(state.message)),
                              ],
                            ),
                            backgroundColor: AppColors.text,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            margin: const EdgeInsets.all(16),
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      final isLoading = state is AuthLoading;
                      return AutofillGroup(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const AuthHeader(title: 'Reset password'),
                            const SizedBox(height: 16),
                            Text(
                              'Enter the 6-digit recovery code sent to ${widget.email} and choose your new password.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textSecondary,
                                    height: 1.5,
                                  ),
                            ),
                            const SizedBox(height: 32),
                            AuthInputField(
                              label: 'Verification code',
                              hint: 'Enter 6-digit code',
                              controller: _code,
                              focusNode: _codeFocus,
                              keyboardType: TextInputType.number,
                              autofillHints: const [AutofillHints.oneTimeCode],
                              textInputAction: TextInputAction.next,
                              errorText: _codeError,
                              prefixIcon: const Icon(Icons.confirmation_number_outlined, size: 20),
                              onSubmitted: (_) => _newPasswordFocus.requestFocus(),
                            ),
                            const SizedBox(height: 16),
                            AuthInputField(
                              label: _toSentenceCase(l10n.newPassword),
                              hint: 'Minimum 6 characters',
                              controller: _newPassword,
                              focusNode: _newPasswordFocus,
                              isPassword: true,
                              autofillHints: const [AutofillHints.newPassword],
                              textInputAction: TextInputAction.next,
                              errorText: _newPasswordError,
                              prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                              onSubmitted: (_) => _confirmFocus.requestFocus(),
                            ),
                            const SizedBox(height: 16),
                            AuthInputField(
                              label: _toSentenceCase(l10n.confirmPassword),
                              hint: 'Repeat password',
                              controller: _confirmNewPassword,
                              focusNode: _confirmFocus,
                              isPassword: true,
                              autofillHints: const [AutofillHints.newPassword],
                              textInputAction: TextInputAction.done,
                              errorText: _confirmError,
                              prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                              onSubmitted: (_) => _submit(context, l10n),
                            ),
                            const SizedBox(height: 32),
                            Semantics(
                              button: true,
                              enabled: !isLoading,
                              label: 'Reset password',
                              child: FilledButton(
                                onPressed: isLoading ? null : () => _submit(context, l10n),
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
                                  minimumSize: const Size(double.infinity, 52),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.2),
                                      )
                                    : const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('Reset password', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                          SizedBox(width: 8),
                                          Icon(Icons.lock_reset_rounded, size: 18),
                                        ],
                                      ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
