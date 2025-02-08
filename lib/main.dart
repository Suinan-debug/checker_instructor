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
        primaryColor: const Color.fromARGB(255, 154, 139, 224), // rgba(0, 19, 173, 1)
     
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: const Color(0xFFFFf200)),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromRGBO(0, 12, 145, 1), // Example: Blue app bar
          foregroundColor: Colors.white, // Example: White text on app bar
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black), // Example: Black body text
        ),
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