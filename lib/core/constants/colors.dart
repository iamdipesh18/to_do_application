// This line imports the Flutter Material library, which gives us access
// to common design widgets and tools used in most Flutter apps.
import 'package:flutter/material.dart';

// This class holds all the colors used in the app so that we can manage them in one place.
// It makes the code cleaner and easier to update later.
class AppColors {
  // The main color of the app, usually used for buttons, headers, etc.
  // Hex code 0xFF4CAF50 is a shade of green.
  static const Color primary = Color(0xFF4CAF50); // Green

  // A secondary color that complements the primary one.
  // This shade of lime green (0xFFCDDC39) can be used for highlights or accents.
  static const Color secondary = Color(0xFFCDDC39); // Lime

  // The background color used across the app.
  // This is a very light grey (0xFFF5F5F5), often used to make other colors stand out.
  static const Color background = Color(0xFFF5F5F5); // Light Grey

  // The color used for individual task tiles (cards).
  // Colors.white is a predefined white color from Flutter's Colors class.
  static const Color taskTile = Colors.white;

  // The color used for tasks that are completed.
  // This grey color (0xFFBDBDBD) helps visually show that the task is done.
  static const Color completedTask = Color(0xFFBDBDBD); // Greyed out

  // The color used to indicate a high-priority task.
  // This red color (0xFFD32F2F) usually grabs attention quickly.
  static const Color highPriority = Color(0xFFD32F2F); // Red

  // The color for medium-priority tasks.
  // This amber shade (0xFFFFA000) is a warm color that signals moderate urgency.
  static const Color mediumPriority = Color(0xFFFFA000); // Amber

  // The color used for low-priority tasks.
  // This darker green (0xFF388E3C) is calm and subtle.
  static const Color lowPriority = Color(0xFF388E3C); // Dark Green
}
