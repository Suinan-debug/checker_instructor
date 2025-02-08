import 'package:checker_instructor/screen/login.dart';
import 'package:flutter/material.dart';

void main() => runApp(AttendanceApp());

class AttendanceApp extends StatelessWidget {
  const AttendanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employee Attendance',
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(0, 19, 173, 1), // rgba(0, 19, 173, 1)
        // or
        // primaryColor: const Color(0xFF0013AD), // #0013AD (hex)

        // If you want to use the yellow as an accent color:
        // accentColor: const Color(0xFFFFf200), // #fff200 (hex)
        // or
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: const Color(0xFFFFf200)),

        // If you want to customize other colors (e.g., app bar, text):
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromRGBO(0, 19, 173, 1), // Example: Blue app bar
          foregroundColor: Colors.white, // Example: White text on app bar
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black), // Example: Black body text
          // ... other text styles
        ),
        // If you want to use a specific color for ElevatedButton background:
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(0, 19, 173, 1), // Example: Blue buttons
            foregroundColor: Colors.white, // White text on the button
          ),
        ),
        // ... other theme customizations as needed
      ),
      home: LoginScreen(),
    );
  }
}