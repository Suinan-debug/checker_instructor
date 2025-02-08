import 'package:checker_instructor/screen/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

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
          bottom: TabBar(
            tabs: [
              const Tab(text: 'East Wing'),
              const Tab(text: 'West Wing'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {
                _showDayFilterDialog(context);
              },
            ),
          ],
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
            } else {
              print("Archived tapped");
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
        ),
        Expanded(
          child: ListView.builder(
            itemCount: instructors.length,
            itemBuilder: (context, index) {
              final instructor = instructors[index];
              return Card( // The outer Card for the list tile
          elevation: 4.0, // Add some elevation for a "card" look
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Add margin
          shape: RoundedRectangleBorder( // Rounded corners
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Container( // Container for background color and padding
            decoration: BoxDecoration(
              color: Colors.blue[100], // Light blue background
              borderRadius: BorderRadius.circular(12.0), // Match card's border radius
            ),
            padding: const EdgeInsets.all(16.0), // Add padding within the card
            child: ListTile(
              title: Text(
                instructor.name,
                style: const TextStyle(fontWeight: FontWeight.bold), // Bold instructor name
              ),
                  subtitle: Column(
                    // Use a Column for the subtitle
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align text to the start
                    children: [
                      Text('Room No.: ${instructor.subject.roomNo}'),
                      Text('Subject: ${instructor.subject.subject}'),
                      Text(
                          'Time: ${_formatTimeRange(instructor.subject.startTime, instructor.subject.endTime)}'),
                    ],
                  ), // Updated subtitle
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AttendanceRow(
                        subject: instructor.subject,
                        onAttendanceChanged: (newStatus, time) {
                          setState(() {
                            instructor.subject.attendance = newStatus;
                            instructor.subject.attendanceTime = time;
                            if (newStatus != null) {
                              archives[wingName]!.add(instructor.subject);
                              wings[wingName]![
                                      DateFormat('EEEE').format(_selectedDate)]!
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
                ),
              ));
            },
          ),
        ),
      ],
    );
  }

  void _showDayFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filter by Day'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              // Define the days of the week explicitly. This ensures consistency.
              final List<String> daysOfWeek = [
                'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday',
                'Saturday', 'Sunday' // Add Sunday
              ];

              return DropdownButton<String>(
                value:
                    _selectedDay, // Ensure _selectedDay is initialized correctly
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedDay = newValue;
                    });
                  }
                },
                items: daysOfWeek.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {}); // Rebuild with the selected day
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

// In your _AttendanceScreenState's initState or wherever you initialize _selectedDay:
  @override
  void initState() {
    super.initState();
    _selectedDay =
        DateFormat('EEEE').format(DateTime.now()); // Initialize _selectedDay
    // Ensure the day from DateFormat('EEEE') exists in your daysOfWeek list!
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
  //   return Row(
  //     mainAxisSize: MainAxisSize.min,
  //     children: [
  //       ElevatedButton(
  //         onPressed: () {
  //           _showConfirmationDialog(context, 'Present');
  //         },
  //         style: ElevatedButton.styleFrom(
  //           backgroundColor: Colors.green, // Set background color to green
  //           foregroundColor:
  //               Colors.white, // Text color to white for better contrast
  //         ),
  //         child: Text('Present'),
  //       ),
  //       SizedBox(width: 8),
  //       ElevatedButton(
  //         onPressed: () {
  //           _showConfirmationDialog(context, 'Absent');
  //         },
  //         style: ElevatedButton.styleFrom(
  //           backgroundColor: Colors.red, // Set background color to red
  //           foregroundColor:
  //               Colors.white, // Text color to white for better contrast
  //         ),
  //         child: Text('Absent'),
  //       ),
  //     ],
  //   );
  // }

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

class Instructor {
  final String name;
  final Subject subject;
  String? remark;

  Instructor(this.name, this.subject, {this.remark});
}

class Subject {
  final String roomNo;
  final String subject;
  final String startTime; // Store start time
  final String endTime; // Store end time
  String? attendance;
  DateTime? attendanceTime;
  String? remark;
  DateTime? lateTime;

  Subject(this.roomNo, this.subject, this.startTime,
      {this.endTime = "", // Make endTime optional
      this.attendance,
      this.attendanceTime,
      this.remark,
      this.lateTime});
}

class ArchiveScreen extends StatefulWidget {
  final List<Subject> eastWingArchive;
  final List<Subject> westWingArchive;

  const ArchiveScreen(
      {super.key,
      required this.eastWingArchive,
      required this.westWingArchive});

  @override
  _ArchiveScreenState createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  DateTime _selectedArchiveDate = DateTime.now();
  CalendarFormat _archiveCalendarFormat = CalendarFormat.week;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Attendance Archive'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'East Wing'),
              Tab(text: 'West Wing'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildArchiveView(widget.eastWingArchive, 'East Wing'),
            _buildArchiveView(widget.westWingArchive, 'West Wing'),
          ],
        ),
      ),
    );
  }

  Widget _buildArchiveView(List<Subject> archive, String wing) {
    List<Subject> filteredArchive = archive
        .where((subject) => isSameDay(
            subject.attendanceTime ?? DateTime.now(), _selectedArchiveDate))
        .toList();

    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime.utc(2010, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _selectedArchiveDate,
          calendarFormat: _archiveCalendarFormat,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedArchiveDate, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedArchiveDate = selectedDay;
            });
          },
          onFormatChanged: (format) {
            setState(() {
              _archiveCalendarFormat = format;
            });
          },
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredArchive.length,
            itemBuilder: (context, index) {
              final subject = filteredArchive[index];

              String formattedDateTime = subject.attendanceTime != null
                  ? DateFormat('MMMM d, yyyy hh:mm a')
                      .format(subject.attendanceTime!)
                  : 'N/A';

              String formattedLateTime = subject.lateTime != null
                  ? DateFormat('MMMM d, yyyy hh:mm a').format(subject.lateTime!)
                  : 'N/A';

              return ListTile(
                title: Text(
                    '${subject.roomNo} - ${subject.subject} (${subject.startTime})'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        '${subject.attendance ?? 'N/A'} at $formattedDateTime'),
                    if (subject.remark != null)
                      Text('Remark: ${subject.remark}'),
                    if (subject.lateTime != null)
                      Text('Late Time: $formattedLateTime'),
                  ],
                ),
                trailing: subject.attendance !=
                        'Late' // Show "Mark Late" only if not already late
                    ? ElevatedButton(
                        onPressed: () {
                          _markLate(subject, wing); // Pass the wing name
                        },
                        child: Text('Mark Late'),
                      )
                    : null,
              );
            },
          ),
        ),
      ],
    );
  }

  void _markLate(Subject subject, String wing) {
    setState(() {
      subject.attendance = 'Late';
      subject.lateTime = DateTime.now();

      // Update the original archive list as well (important!)
      if (wing == 'East Wing') {
        int index = widget.eastWingArchive.indexOf(subject);
        if (index != -1) {
          widget.eastWingArchive[index] = subject;
        }
      } else {
        // West Wing
        int index = widget.westWingArchive.indexOf(subject);
        if (index != -1) {
          widget.westWingArchive[index] = subject;
        }
      }
    });
  }
}

String _formatTimeRange(String startTime, String endTime) {
  if (endTime.isNotEmpty) {
    return '$startTime to $endTime';
  } else {
    return startTime; // Only show start time if end time is not provided
  }
}
