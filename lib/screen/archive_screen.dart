import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/instructor.dart'; // Import necessary classes

class ArchiveScreen extends StatefulWidget {
  final List<Subject> eastWingArchive;
  final List<Subject> westWingArchive;
  final Map<String, Map<String, List<Instructor>>> wings;

  const ArchiveScreen({
    super.key,
    required this.eastWingArchive,
    required this.westWingArchive,
    required this.wings,
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
          title: Text('Attendance Archive'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'East Wing'),
              Tab(text: 'West Wing'),
            ],
          ),
          backgroundColor: Colors.blue, // Blue theme color
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
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: Colors.blue, // Blue theme color
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: Colors.yellow, // Yellow theme color
              shape: BoxShape.circle,
            ),
          ),
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyle(
              color: Colors.blue, // Blue theme color
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredArchive.length,
            itemBuilder: (context, index) {
              final subject = filteredArchive[index];
              final instructor = _getInstructorForSubject(subject, wing);

              String formattedDateTime = subject.attendanceTime != null
                  ? DateFormat('MMMM d, yyyy hh:mm a')
                      .format(subject.attendanceTime!)
                  : 'N/A';

              String formattedLateTime = subject.lateTime != null
                  ? DateFormat('MMMM d, yyyy hh:mm a').format(subject.lateTime!)
                  : 'N/A';

              Color statusColor;
              if (subject.attendance == 'Present') {
                statusColor = Colors.green;
              } else if (subject.attendance == 'Absent') {
                statusColor = Colors.red;
              } else {
                statusColor = Colors.transparent;
              }

              return Card(
                elevation: 4.0,
                margin: const EdgeInsets.symmetric(
                    vertical: 8.0, horizontal: 16.0),
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
                          '${subject.roomNo} - ${subject.subject} (${subject.startTime})',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        if (instructor != null)
                          Text('Instructor: ${instructor.name}'),
                        Text(
                          'Time: ${_formatTimeRange(subject.startTime, subject.endTime)}',
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          color: statusColor,
                          child: Text(
                            '${subject.attendance ?? 'N/A'} at $formattedDateTime',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        if (subject.remark != null)
                          Text('Remark: ${subject.remark}'),
                        if (subject.lateTime != null)
                          Text('Late Time: $formattedLateTime'),
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (subject.attendance != 'Late' &&
                                subject.attendance != 'Present')
                              ElevatedButton(
                                onPressed: () {
                                  _markLate(subject, wing);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                ),
                                child: Text('Mark Late'),
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

  Instructor? _getInstructorForSubject(Subject subject, String wing) {
    final wingData = widget.wings[wing];
    if (wingData != null) {
      for (final day in wingData.values) {
        for (final instructor in day) {
          if (instructor.subject.roomNo == subject.roomNo &&
              instructor.subject.subject == subject.subject &&
              instructor.subject.startTime == subject.startTime) {
            return instructor;
          }
        }
      }
    }
    return null;
  }

  void _markLate(Subject subject, String wing) {
    setState(() {
      subject.attendance = 'Late';
      subject.lateTime = DateTime.now();

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

  String _formatTimeRange(String startTime, String endTime) {
    if (endTime.isNotEmpty) {
      return '$startTime to $endTime';
    } else {
      return startTime;
    }
  }
}
