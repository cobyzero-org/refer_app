import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:refer_app/l10n/app_localizations.dart';
import '../../../core/di.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'widgets/auth_input_field.dart';
import 'widgets/auth_header.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _email = TextEditingController(text: 'admin@admin.com');
  final _password = TextEditingController(text: 'admin');

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (context) => sl<AuthBloc>(),
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthAuthenticated) {
                      context.go('/main');
                    }
                    if (state is AuthError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const AuthHeader(),
                        const SizedBox(height: 48),
                        AuthInputField(
                          label: l10n.email,
                          hint: l10n.emailHint,
                          controller: _email,
                        ),
                        const SizedBox(height: 24),
                        AuthInputField(
                          label: l10n.password,
                          hint: l10n.passwordHint,
                          controller: _password,
                          isPassword: true,
                        ),
                        const SizedBox(height: 12),
                        _buildForgotPasswordBtn(l10n),
                        const SizedBox(height: 32),
                        _buildSignInBtn(context, state, l10n),
                        const SizedBox(height: 48),
                        //const AuthDivider(),
                        //const SizedBox(height: 40),
                        //_buildSocialRow(l10n),
                        //const SizedBox(height: 48),
                        _buildSignupLink(l10n),
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

  Widget _buildForgotPasswordBtn(AppLocalizations l10n) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(onPressed: () {}, child: Text(l10n.forgotPassword)),
    );
  }

  Widget _buildSignInBtn(
    BuildContext context,
    AuthState state,
    AppLocalizations l10n,
  ) {
    return ElevatedButton(
      onPressed: state is AuthLoading
          ? null
          : () {
              context.read<AuthBloc>().add(
                LoginRequested(_email.text, _password.text),
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
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(l10n.signIn),
                const SizedBox(width: 10),
                const Icon(Icons.arrow_forward, size: 18),
              ],
            ),
    );
  }

  /*Widget _buildSocialRow(AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: AuthSocialButton(
            icon: Icons.g_mobiledata,
            label: l10n.google,
            onPressed: () {},
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: AuthSocialButton(
            icon: Icons.apple,
            label: l10n.apple,
            onPressed: () {},
          ),
        ),
      ],
    );
  }*/

  Widget _buildSignupLink(AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.dontHaveAccount,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        TextButton(
          onPressed: () => context.go('/signup'),
          child: Text(l10n.signUp),
        ),
      ],
    );
  }
}
