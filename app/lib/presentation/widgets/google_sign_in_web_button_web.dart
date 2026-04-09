import 'package:flutter/material.dart';
import 'package:google_sign_in_web/web_only.dart' as google_sign_in_web;

/// Builds the web-specific Google sign-in button when available.
Widget buildGoogleSignInWebButton(BuildContext context) {
  return google_sign_in_web.renderButton(
    configuration: google_sign_in_web.GSIButtonConfiguration(
      theme: google_sign_in_web.GSIButtonTheme.outline,
      size: google_sign_in_web.GSIButtonSize.large,
      text: google_sign_in_web.GSIButtonText.signinWith,
      minimumWidth: 220,
      locale: Localizations.localeOf(context).languageCode,
    ),
  );
}
