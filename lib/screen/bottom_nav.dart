import 'package:flutter/material.dart';

class MyBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChanged;

  const MyBottomNavigationBar({super.key, 
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.archive),
          label: 'Archive',
        ),
      ],
      currentIndex: selectedIndex,
      onTap: onTabChanged, // Call the callback function
    );
  }
}
