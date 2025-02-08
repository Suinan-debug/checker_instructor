import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class Instructor {
  final String name;
  final Subject subject;
  String? remark;

  Instructor(this.name, this.subject, {this.remark});
}

class Subject {
  final String roomNo;
  final String subject;
  final String startTime;
  final String endTime;
  String? attendance;
  DateTime? attendanceTime;
  String? remark;
  DateTime? lateTime;

  Subject(this.roomNo, this.subject, this.startTime,
      {this.endTime = "",
      this.attendance,
      this.attendanceTime,
      this.remark,
      this.lateTime});
}

class ArchiveScreen extends StatefulWidget {
  final List<Subject> eastWingArchive;
  final List<Subject> westWingArchive;

  const ArchiveScreen({
    super.key,
    required this.eastWingArchive,
    required this.westWingArchive,
  });

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
          title: const Text('Attendance Archive'),
          bottom: TabBar(
            tabs: const [
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
                trailing: subject.attendance != 'Late'
                    ? ElevatedButton(
                        onPressed: () {
                          _markLate(subject, wing);
                        },
                        child: const Text('Mark Late'),
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
    return startTime;
  }
}

class AttendanceRow extends StatefulWidget {
  final Subject subject;
  final Function(String?, DateTime?) onAttendanceChanged;
  final bool isToday;

  const AttendanceRow({
    super.key,
    required this.subject,
    required this.onAttendanceChanged,
    required this.isToday,
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
          onPressed: widget.isToday
              ? () {
                  _showConfirmationDialog(context, 'Present');
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          child: const Text('Present'),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: widget.isToday
              ? () {
                  _showConfirmationDialog(context, 'Absent');
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: const Text('Absent'),
        ),
      ],
    );
  }

  void _showConfirmationDialog(BuildContext context, String status) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Attendance'),
          content: Text('Are you sure you want to mark this as $status?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _markAttendance(status);
                Navigator.pop(context);
              },
              child: const Text('Confirm'),
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