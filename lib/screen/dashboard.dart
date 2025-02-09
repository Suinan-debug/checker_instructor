import 'package:checker_instructor/screen/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'archive_screen.dart'; // Import the ArchiveScreen
import 'add_instructor.dart'; // Import the AddInstructorScreen
import '../models/instructor.dart'; // Import the Instructor and Subject classes

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  Map<String, Map<String, List<Instructor>>> wings = {
    'East Wing': {
      'Monday': [
        Instructor('Mr. Monday East',
            Subject('Room 101', 'Math', '8:00 AM', endTime: '9:30 AM')),
        Instructor('Prof. Mondat East',
            Subject('Room 103', 'English', '10:00 AM', endTime: '11:00 AM')),
      ],
      'Tuesday': [
        Instructor('Dr. Tuesday East',
            Subject('Room 102', 'Science', '9:00 AM', endTime: '10:30 AM')),
      ],
      'Wednesday': [
        Instructor('Dr. Wednesday East',
            Subject('Room 102', 'Science', '9:00 AM', endTime: '10:30 AM')),
      ],
      'Thursday': [
        Instructor('Dr. Thursday East',
            Subject('Room 102', 'Science', '9:00 AM', endTime: '10:30 AM')),
      ],
      'Friday': [
        Instructor('Dr. Friday East',
            Subject('Room 102', 'Science', '9:00 AM', endTime: '10:30 AM')),
      ],
      'Saturday': [
        Instructor('Dr. Saturday East 2',
            Subject('Room 201', 'History', '8:00 AM', endTime: '9:00 AM')),
        Instructor('Dr. Saturday East',
            Subject('Room 202', 'Chemistry', '9:00 AM', endTime: '10:00 AM')),
      ],
      'Sunday': [
        Instructor('Dr. Sunday East',
            Subject('Room 201', 'History', '8:00 AM', endTime: '9:00 AM')),
      ],
    },
    'West Wing': {
      'Monday': [
        Instructor('Dr. Monday West 2',
            Subject('Room 201', 'History', '8:00 AM', endTime: '9:00 AM')),
        Instructor('Dr. Monday WEst 1',
            Subject('Room 202', 'Chemistry', '9:00 AM', endTime: '10:00 AM')),
      ],
      'Tuesday': [
        Instructor('Dr. Tuesday West',
            Subject('Room 102', 'Science', '9:00 AM', endTime: '10:30 AM')),
      ],
      'Wednesday': [
        Instructor('Dr. Wednesday West',
            Subject('Room 102', 'Science', '9:00 AM', endTime: '10:30 AM')),
      ],
      'Thursday': [
        Instructor('Dr. Thursday West',
            Subject('Room 102', 'Science', '9:00 AM', endTime: '10:30 AM')),
      ],
      'Friday': [
        Instructor('Dr. Friday Wesy',
            Subject('Room 102', 'Science', '9:00 AM', endTime: '10:30 AM')),
      ],
      'Saturday': [
        Instructor('Dr. Saturday West1',
            Subject('Room 201', 'History', '8:00 AM', endTime: '9:00 AM')),
        Instructor('Dr. Saturday West 2',
            Subject('Room 202', 'Chemistry', '9:00 AM', endTime: '10:00 AM')),
      ],
      'Sunday': [
        Instructor('Dr. Sunday West',
            Subject('Room 201', 'History', '8:00 AM', endTime: '9:00 AM')),
      ],
    },
  };

  Map<String, List<Subject>> archives = {
    'East Wing': [],
    'West Wing': [],
  };

  int _selectedIndex = 0;
  DateTime _today = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.week;
  String _selectedDay = '';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Employee Attendance'),
          backgroundColor: Colors.blue,
          bottom: TabBar(
            tabs: [
              const Tab(text: 'East Wing'),
              const Tab(text: 'West Wing'),
            ],
            indicatorColor: Colors.yellow,
          ),
        ),
        body: TabBarView(
          children: [
            _buildWingView('East Wing'),
            _buildWingView('West Wing'),
          ],
        ),
        bottomNavigationBar: MyBottomNavigationBar(
          selectedIndex: _selectedIndex,
          onTabChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
            if (index == 1) {
              _showArchive(context);
            } else if (index == 2) {
              _showAddInstructor(context);
            } else {
              print("Home tapped");
            }
          },
        ),
      ),
    );
  }

  Widget _buildWingView(String wingName) {
    List<Instructor> instructors = List.from(
        wings[wingName]?[DateFormat('EEEE').format(_selectedDate)] ?? []);

    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime.utc(2010, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _selectedDate,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDate, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDate = selectedDay;
            });
          },
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: Colors.yellow,
              shape: BoxShape.circle,
            ),
          ),
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: instructors.length,
            itemBuilder: (context, index) {
              final instructor = instructors[index];
              return Card(
                elevation: 4.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: InkWell(
                  onTap: () {
                    // Handle tap on the card if needed
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          instructor.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text('Room No.: ${instructor.subject.roomNo}'),
                        Text('Subject: ${instructor.subject.subject}'),
                        Text(
                          'Time: ${_formatTimeRange(instructor.subject.startTime, instructor.subject.endTime)}',
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AttendanceRow(
                              subject: instructor.subject,
                              onAttendanceChanged: (newStatus, time) {
                                setState(() {
                                  instructor.subject.attendance = newStatus;
                                  instructor.subject.attendanceTime = time;
                                  if (newStatus != null) {
                                    archives[wingName]!.add(instructor.subject);
                                    wings[wingName]![DateFormat('EEEE')
                                            .format(_selectedDate)]!
                                        .remove(instructor);
                                    instructors.removeAt(index);
                                  }
                                });
                              },
                              isToday: isSameDay(_selectedDate, _today),
                            ),
                            IconButton(
                              icon: const Icon(Icons.comment),
                              onPressed: isSameDay(_selectedDate, _today)
                                  ? () {
                                      _showRemarkModal(context, instructor);
                                    }
                                  : null,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _selectedDay =
        DateFormat('EEEE').format(DateTime.now()); // Initialize _selectedDay
    if (!daysOfWeek.contains(_selectedDay)) {
      _selectedDay = daysOfWeek[0]; // Default to the first day if not found
    }
  }

  void _showRemarkModal(BuildContext context, Instructor instructor) {
    String remark = instructor.remark ?? '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController controller =
            TextEditingController(text: remark); // Use controller

        return AlertDialog(
          title: Text('Instructor Remark'),
          content: TextField(
            controller: controller, // Assign the controller
            onChanged: (value) =>
                remark = value, // Still update the remark variable
            maxLines: 3,
            decoration: InputDecoration(hintText: 'Enter remark'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  instructor.remark = remark; // Update instructor's remark
                  instructor.subject.remark =
                      remark; // Update subject's remark too if needed
                });
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showArchive(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArchiveScreen(
          eastWingArchive: archives['East Wing']!,
          westWingArchive: archives['West Wing']!,
          wings: wings, // Pass wings data
        ),
      ),
    );
  }

  void _showAddInstructor(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddInstructorScreen(
          onInstructorAdded: (instructor, wing, day) {
            setState(() {
              wings[wing]![day]!.add(instructor); // Add to selected wing and day
            });
          },
        ),
      ),
    );
  }
}

class AttendanceRow extends StatefulWidget {
  final Subject subject;
  final Function(String?, DateTime?) onAttendanceChanged;
  final bool isToday; // Add isToday parameter

  const AttendanceRow({
    super.key,
    required this.subject,
    required this.onAttendanceChanged,
    required this.isToday, // Initialize isToday
  });

  @override
  _AttendanceRowState createState() => _AttendanceRowState();
}

class _AttendanceRowState extends State<AttendanceRow> {
  String? attendanceStatus;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: widget.isToday // Disable if not today
              ? () {
                  _showConfirmationDialog(context, 'Present');
                }
              : null, // Disable the button
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          child: Text('Present'),
        ),
        SizedBox(width: 8),
        ElevatedButton(
          onPressed: widget.isToday // Disable if not today
              ? () {
                  _showConfirmationDialog(context, 'Absent');
                }
              : null, // Disable the button
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: Text('Absent'),
        ),
      ],
    );
  }

  void _showConfirmationDialog(BuildContext context, String status) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Attendance'),
          content: Text('Are you sure you want to mark this as $status?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close the dialog
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _markAttendance(status);
                Navigator.pop(context); // Close the dialog after marking
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _markAttendance(String status) {
    setState(() {
      attendanceStatus = status;
      DateTime now = DateTime.now();
      widget.onAttendanceChanged(attendanceStatus, now);
    });
  }
}

String _formatTimeRange(String startTime, String endTime) {
  if (endTime.isNotEmpty) {
    return '$startTime to $endTime';
  } else {
    return startTime;
  }
}
