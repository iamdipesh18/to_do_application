import 'package:flutter/material.dart';

/// Define all main colors for your app here.
/// This helps avoid repeating color values everywhere.

class AppColors {
  static const Color primary = Colors.indigo;
  static const Color primaryLight = Color(0xFFC5CAE9); // light indigo shade
  static const Color primaryDark = Color(0xFF303F9F);  // dark indigo shade

  static const Color success = Colors.green;
  static const Color warning = Colors.orange;
  static const Color error = Colors.red;

  static const Color background = Colors.white;
  static const Color surface = Colors.grey; // for cards, containers
  static const Color onPrimary = Colors.white; // text/icons on primary color

  // You can add more colors as needed for your theme.
}
