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

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _email = TextEditingController();
  final _emailFocus = FocusNode();
  String? _emailError;

  @override
  void dispose() {
    _email.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  void _submit(BuildContext blocContext) {
    final l10n = AppLocalizations.of(context)!;
    final email = _email.text.trim();
    setState(() {
      _emailError = email.isEmpty || !email.contains('@') ? l10n.enterValidEmail : null;
    });
    if (_emailError != null) {
      HapticFeedback.selectionClick();
      return;
    }
    FocusScope.of(context).unfocus();
    TextInput.finishAutofillContext();
    blocContext.read<AuthBloc>().add(ForgotPasswordRequested(email));
  }

  String _toSentenceCase(String input) {
    if (input == input.toUpperCase() && input.length <= 20) {
      return input[0].toUpperCase() + input.substring(1).toLowerCase();
    }
    return input;
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
                      if (state is ForgotPasswordSuccess) {
                        AppSnackBar.success(context, l10n.recoveryCodeSent);
                        context.push('/reset-password?email=${Uri.encodeComponent(_email.text)}');
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
                            AuthHeader(title: l10n.recoverPassword),
                            const SizedBox(height: 16),
                            Text(
                              l10n.recoverPasswordSubtitle,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textSecondary,
                                    height: 1.5,
                                  ),
                            ),
                            const SizedBox(height: 32),
                            AuthInputField(
                              label: _toSentenceCase(l10n.email),
                              hint: l10n.emailHint,
                              controller: _email,
                              focusNode: _emailFocus,
                              keyboardType: TextInputType.emailAddress,
                              autofillHints: const [AutofillHints.email],
                              textInputAction: TextInputAction.done,
                              errorText: _emailError,
                              prefixIcon: const Icon(Icons.mail_outline_rounded, size: 20),
                              onSubmitted: (_) => _submit(context),
                            ),
                            const SizedBox(height: 32),
                            Semantics(
                              button: true,
                              enabled: !isLoading,
                              label: l10n.sendCode,
                              child: FilledButton(
                                onPressed: isLoading ? null : () => _submit(context),
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
                                          Text(l10n.sendCode, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                          const SizedBox(width: 8),
                                          const Icon(Icons.send_rounded, size: 18),
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
