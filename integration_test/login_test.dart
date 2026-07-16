import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:refer_app/main.dart' as app;
import 'package:refer_app/core/router.dart';

void main() {
  patrolTest(
    'login flow test',
    ($) async {
      // Start the application
      await app.main();
      await $.pumpAndSettle();

      // Bypass splash screen redirecting to maintenance by navigating directly to /auth
      router.go('/auth');
      await $.pumpAndSettle();

      // Find the email input field (the first TextField)
      final emailField = $(TextField).at(0);
      // Find the password input field (the second TextField)
      final passwordField = $(TextField).at(1);
      // Find the Sign In button
      final signInButton = $(ElevatedButton);

      // Verify they are visible on the login screen
      expect(emailField, findsOneWidget);
      expect(passwordField, findsOneWidget);
      expect(signInButton, findsOneWidget);

      // Enter login credentials
      await $.enterText(emailField, 'admin@admin.com');
      await $.enterText(passwordField, 'admin');
      await $.pumpAndSettle();

      // Tap on Sign In button
      await $.tap(signInButton);
      await $.pumpAndSettle();
    },
  );
}
