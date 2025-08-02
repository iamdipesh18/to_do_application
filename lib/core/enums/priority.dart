// This imports the Hive package, which is a lightweight and fast local database
// used in Flutter apps to store data on the device.
import 'package:hive/hive.dart';

// This line is required by Hive. It allows code generation for this file.
// Hive will create a file called 'priority.g.dart' with code that helps it store enum values.
part 'priority.g.dart';

// This annotation tells Hive that this enum is something we want to store in the database.
// typeId must be unique for each type in your app. It helps Hive identify what kind of object this is.
@HiveType(typeId: 1)
enum Priority {
  // Each priority level is given a number using @HiveField.
  // These numbers are stored in the database to represent the enum values.

  @HiveField(0)
  low, // Represents a low-priority task

  @HiveField(1)
  medium, // Represents a medium-priority task

  @HiveField(2)
  high, // Represents a high-priority task
}

// This extension adds extra functionality to the Priority enum.
// It allows you to get a readable label (string) from the enum value.
extension PriorityExtension on Priority {
  // This getter returns a text label for the priority value.
  // It's useful when displaying the priority as a string in the UI.
  String get label {
    // This 'switch' checks which enum value is currently being used
    // and returns the matching string.
    switch (this) {
      case Priority.low:
        return 'Low';
      case Priority.medium:
        return 'Medium';
      case Priority.high:
        return 'High';
    }
  }
}
