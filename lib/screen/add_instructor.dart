import 'package:flutter/material.dart';
import '../models/instructor.dart'; // Import the Instructor and Subject classes

class AddInstructorScreen extends StatefulWidget {
  final Function(Instructor, String, String) onInstructorAdded;

  const AddInstructorScreen({super.key, required this.onInstructorAdded});

  @override
  _AddInstructorScreenState createState() => _AddInstructorScreenState();
}

class _AddInstructorScreenState extends State<AddInstructorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _roomNoController = TextEditingController();
  final _subjectController = TextEditingController();
  final _timeStartController = TextEditingController();
  final _timeEndController = TextEditingController();
  String _selectedWing = 'East Wing';
  String _selectedDay = 'Monday';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Instructor'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _roomNoController,
                decoration: const InputDecoration(labelText: 'Room No'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a room number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _subjectController,
                decoration: const InputDecoration(labelText: 'Subject'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a subject';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _timeStartController,
                decoration: const InputDecoration(labelText: 'Start Time (e.g., 8:00 AM)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a start time';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _timeEndController,
                decoration: const InputDecoration(labelText: 'End Time (e.g., 5:00 PM)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an end time';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedWing,
                decoration: const InputDecoration(labelText: 'Wing'),
                items: ['East Wing', 'West Wing'].map((String wing) {
                  return DropdownMenuItem<String>(
                    value: wing,
                    child: Text(wing),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedWing = newValue!;
                  });
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedDay,
                decoration: const InputDecoration(labelText: 'Day'),
                items: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'].map((String day) {
                  return DropdownMenuItem<String>(
                    value: day,
                    child: Text(day),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedDay = newValue!;
                  });
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final instructor = Instructor(
                      _nameController.text,
                      Subject(
                        _roomNoController.text,
                        _subjectController.text,
                        _timeStartController.text,
                        endTime: _timeEndController.text,
                      ),
                    );
                    widget.onInstructorAdded(instructor, _selectedWing, _selectedDay);
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blue,
                ),
                child: const Text('Add Instructor'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roomNoController.dispose();
    _subjectController.dispose();
    _timeStartController.dispose();
    _timeEndController.dispose();
    super.dispose();
  }
}