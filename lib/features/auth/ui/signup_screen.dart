import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/di.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'widgets/auth_input_field.dart';
import 'widgets/auth_header.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  bool _acceptTerms = false;
  bool _keepUpdated = true;

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
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Account created successfully!")),
                      );
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
                        const AuthHeader(
                          title: "Create Account",
                          subtitle: "Begin your sensory journey with us.",
                        ),
                        const SizedBox(height: 48),
                        AuthInputField(
                          label: "Full Name",
                          hint: "Elias Thorne",
                          controller: _name,
                        ),
                        const SizedBox(height: 24),
                        AuthInputField(
                          label: "Email",
                          hint: "elias@editorialroast.com",
                          controller: _email,
                        ),
                        const SizedBox(height: 24),
                        AuthInputField(
                          label: "Password",
                          hint: "........",
                          controller: _password,
                          isPassword: true,
                        ),
                        const SizedBox(height: 24),
                        AuthInputField(
                          label: "Confirm Password",
                          hint: "........",
                          controller: _confirmPassword,
                          isPassword: true,
                        ),
                        const SizedBox(height: 24),
                        _buildCheckboxRow(
                          value: _acceptTerms,
                          onChanged: (v) => setState(() => _acceptTerms = v!),
                          label: "I accept the Terms and Conditions and Privacy Policy.",
                        ),
                        const SizedBox(height: 12),
                        _buildCheckboxRow(
                          value: _keepUpdated,
                          onChanged: (v) => setState(() => _keepUpdated = v!),
                          label: "Keep me updated with seasonal collections and exclusive roastery news.",
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: state is AuthLoading || !_acceptTerms
                              ? null
                              : () {
                                  if (_password.text != _confirmPassword.text) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Passwords do not match")),
                                    );
                                    return;
                                  }
                                  context.read<AuthBloc>().add(
                                        RegisterRequested(
                                          _name.text,
                                          _email.text,
                                          _password.text,
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
                              : const Text("Create Account"),
                        ),
                        const SizedBox(height: 24),
                        TextButton(
                          onPressed: () => context.go('/auth'),
                          child: const Text("Already have an account? Sign In"),
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

  Widget _buildCheckboxRow({
    required bool value,
    required ValueChanged<bool?> onChanged,
    required String label,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 13,
                  color: Colors.black87,
                ),
          ),
        ),
      ],
    );
  }
}
