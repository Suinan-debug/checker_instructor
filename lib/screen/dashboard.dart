import 'package:checker_instructor/screen/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  Map<String, Map<String, List<Instructor>>> wings = {
    'East Wing': {
      'Monday': [
        Instructor('Dr. Smith', Subject('Room 101', 'Math', '8:00 AM')),
        Instructor('Prof. Johnson', Subject('Room 103', 'English', '10:00 AM')),
      ],
      'Tuesday': [
        Instructor('Dr. Another', Subject('Room 102', 'Science', '9:00 AM')),
      ],
      'Wednesday': [], // Add schedules for other days
      'Thursday': [],
      'Friday': [],
      'Saturday': [ Instructor('Dr. Lee', Subject('Room 201', 'History', '8:00 AM')),
        Instructor('Dr. Reyes', Subject('Room 202', 'Chemistry', '9:00 AM')),],
        'Sunday': [ Instructor('Dr. Lee', Subject('Room 201', 'History', '8:00 AM')),
        ],
    },
    'West Wing': {
      'Monday': [
        Instructor('Dr. Lee', Subject('Room 201', 'History', '8:00 AM')),
        Instructor('Dr. Reyes', Subject('Room 202', 'Chemistry', '9:00 AM')),
      ],
      'Tuesday': [], // Add schedules for other days
      'Wednesday': [],
      'Thursday': [],
      'Friday': [],
      'Saturday': [ Instructor('Dr. Lee', Subject('Room 201', 'History', '8:00 AM')),
        Instructor('Dr. Reyes', Subject('Room 202', 'Chemistry', '9:00 AM')),],
    },
  };

  Map<String, List<Subject>> archives = {
    'East Wing': [],
    'West Wing': [],
  };

  int _selectedIndex = 0;
  String _selectedDay = DateFormat('EEEE').format(DateTime.now()); // Initially today

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
    String today = DateFormat('EEEE').format(DateTime.now()); // Get the current day
    List<Instructor> instructors =
        List.from(wings[wingName]![today] ?? []); // Get today's instructors

    return ListView.builder(
      itemCount: instructors.length,
      itemBuilder: (context, index) {
        final instructor = instructors[index];
        return Card(
          child: ListTile(
            title: Text(instructor.name),
            subtitle: Text(
                '${instructor.subject.roomNo} - ${instructor.subject.subject} (${instructor.subject.time})'),
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
                        wings[wingName]![today]!.remove(instructor);
                        instructors.remove(instructor);
                      }
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.comment),
                  onPressed: () {
                    _showRemarkModal(context, instructor);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
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

  const AttendanceRow(
      {super.key, required this.subject, required this.onAttendanceChanged});

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
          onPressed: () {
            _showConfirmationDialog(context, 'Present');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green, // Set background color to green
            foregroundColor:
                Colors.white, // Text color to white for better contrast
          ),
          child: Text('Present'),
        ),
        SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            _showConfirmationDialog(context, 'Absent');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red, // Set background color to red
            foregroundColor:
                Colors.white, // Text color to white for better contrast
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

class Instructor {
  final String name;
  final Subject subject;
  String? remark; // Add remark property

  Instructor(this.name, this.subject, {this.remark});
}

class Subject {
  final String roomNo;
  final String subject;
  final String time;
  String? attendance;
  DateTime? attendanceTime;
  String? remark;
  DateTime? lateTime; // Add lateTime property

  Subject(this.roomNo, this.subject, this.time,
      {this.attendance, this.attendanceTime, this.remark, this.lateTime});
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
            _buildArchiveView(widget.eastWingArchive),
            _buildArchiveView(widget.westWingArchive),
          ],
        ),
      ),
    );
  }

  Widget _buildArchiveView(List<Subject> archive) {
    return ListView.builder(
      itemCount: archive.length,
      itemBuilder: (context, index) {
        final subject = archive[index];

        // Format Date and Time in words (e.g., "March 24, 2025 08:30 AM")
        String formattedDateTime = subject.attendanceTime != null
            ? DateFormat('MMMM d, yyyy hh:mm a')
                .format(subject.attendanceTime!) // Modified format
            : 'N/A';

        String formattedLateTime = subject.lateTime != null
            ? DateFormat('MMMM d, yyyy hh:mm a')
                .format(subject.lateTime!) // Modified format
            : 'N/A';

        return ListTile(
          title:
              Text('${subject.roomNo} - ${subject.subject} (${subject.time})'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  '${subject.attendance ?? 'N/A'} at $formattedDateTime'), // Use formatted date and time
              if (subject.remark != null) Text('Remark: ${subject.remark}'),
              if (subject.lateTime != null)
                Text(
                    'Late Time: $formattedLateTime'), // Use formatted late time
            ],
          ),
          trailing: subject.attendance != 'Late'
              ? ElevatedButton(
                  onPressed: () {
                    _markLate(subject);
                  },
                  child: Text('Mark Late'),
                )
              : null,
        );
      },
    );
  }

  void _markLate(Subject subject) {
    setState(() {
      subject.attendance = 'Late';
      subject.lateTime = DateTime.now();
    });
  }
}
