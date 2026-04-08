import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/di.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'widgets/auth_input_field.dart';
import 'widgets/auth_social_button.dart';
import 'widgets/auth_header.dart';
import 'widgets/auth_divider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                          label: "EMAIL",
                          hint: "name@editorialroast.com",
                          controller: _email,
                        ),
                        const SizedBox(height: 24),
                        AuthInputField(
                          label: "PASSWORD",
                          hint: "........",
                          controller: _password,
                          isPassword: true,
                        ),
                        const SizedBox(height: 12),
                        _buildForgotPasswordBtn(),
                        const SizedBox(height: 32),
                        _buildSignInBtn(context, state),
                        const SizedBox(height: 48),
                        const AuthDivider(),
                        const SizedBox(height: 40),
                        _buildSocialRow(),
                        const SizedBox(height: 48),
                        _buildSignupLink(),
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

  Widget _buildForgotPasswordBtn() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {},
        child: const Text("Forgot Password?"),
      ),
    );
  }

  Widget _buildSignInBtn(BuildContext context, AuthState state) {
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
          : const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Sign In"),
                SizedBox(width: 10),
                Icon(Icons.arrow_forward, size: 18),
              ],
            ),
    );
  }

  Widget _buildSocialRow() {
    return Row(
      children: [
        Expanded(
          child: AuthSocialButton(
            icon: Icons.g_mobiledata,
            label: "Google",
            onPressed: () {},
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: AuthSocialButton(
            icon: Icons.apple,
            label: "Apple",
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildSignupLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account?",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        TextButton(
          onPressed: () => context.go('/signup'),
          child: const Text("Sign up"),
        ),
      ],
    );
  }
}
