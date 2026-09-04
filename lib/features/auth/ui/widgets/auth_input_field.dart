import 'package:flutter/material.dart';
import '../../../../core/theme.dart';

class AuthInputField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType? keyboardType;
  final List<String>? autofillHints;
  final TextInputAction? textInputAction;
  final void Function(String)? onSubmitted;
  final String? errorText;
  final FocusNode? focusNode;
  final Widget? prefixIcon;

  const AuthInputField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.isPassword = false,
    this.keyboardType,
    this.autofillHints,
    this.textInputAction,
    this.onSubmitted,
    this.errorText,
    this.focusNode,
    this.prefixIcon,
  });

  @override
  State<AuthInputField> createState() => _AuthInputFieldState();
}

class _AuthInputFieldState extends State<AuthInputField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // HIG Writing: sentence case, not all caps
        Semantics(
          header: true,
          child: Text(
            widget.label,
            style: textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
              color: AppColors.textSecondary,
              fontSize: 12.5,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Semantics(
          textField: true,
          label: widget.label,
          hint: widget.hint,
          child: TextField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            obscureText: _obscure,
            keyboardType: widget.keyboardType ??
                (widget.isPassword ? TextInputType.visiblePassword : TextInputType.emailAddress),
            autofillHints: widget.autofillHints,
            textInputAction: widget.textInputAction,
            autocorrect: false,
            enableSuggestions: !widget.isPassword,
            onSubmitted: widget.onSubmitted,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 16,
                  color: AppColors.text,
                ),
            decoration: InputDecoration(
              hintText: widget.hint,
              errorText: widget.errorText,
              prefixIcon: widget.prefixIcon,
              // Ensure 44pt touch target via suffix icon constraints
              suffixIcon: widget.isPassword
                  ? IconButton(
                      tooltip: _obscure ? 'Show password' : 'Hide password',
                      onPressed: () => setState(() => _obscure = !_obscure),
                      icon: Icon(
                        _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: AppColors.textTertiary,
                        size: 20,
                      ),
                      // HIG Accessibility: 44x44 minimum
                      constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                    )
                  : null,
              suffixIconConstraints: const BoxConstraints(minWidth: 44, minHeight: 44),
            ),
          ),
        ),
      ],
    );
  }
}
