import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:refer_app/l10n/app_localizations.dart';
import 'package:refer_app/core/widgets/app_snackbar.dart';
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
      _codeError = code.length != 6 ? l10n.enter6DigitCode : null;
      _newPasswordError = pwd.length < 6 ? l10n.passwordMinLength : null;
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
            tooltip: l10n.back,
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
                        AppSnackBar.success(context, l10n.passwordResetSuccess);
                        context.go('/auth');
                      }
                      if (state is AuthError) {
                        AppSnackBar.error(context, state.message);
                      }
                    },
                    builder: (context, state) {
                      final isLoading = state is AuthLoading;
                      return AutofillGroup(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AuthHeader(title: l10n.resetPassword),
                            const SizedBox(height: 16),
                            Text(
                              l10n.resetPasswordSubtitle(widget.email),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textSecondary,
                                    height: 1.5,
                                  ),
                            ),
                            const SizedBox(height: 32),
                            AuthInputField(
                              label: l10n.verificationCode,
                              hint: l10n.enter6DigitCodeHint,
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
                              hint: l10n.minimum6Chars,
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
                              hint: l10n.repeatPassword,
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
                              label: l10n.resetPassword,
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
                                    : Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(l10n.resetPassword, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                          const SizedBox(width: 8),
                                          const Icon(Icons.lock_reset_rounded, size: 18),
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
