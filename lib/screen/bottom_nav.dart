import 'package:flutter/material.dart';

class MyBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChanged;

  const MyBottomNavigationBar({
    super.key,
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
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Add Instructor',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.yellow,
      unselectedItemColor: Colors.white,
      backgroundColor: Colors.blue,
      onTap: onTabChanged, // Call the callback function
    );
  }
}
