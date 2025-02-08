import 'package:flutter/material.dart';

class AddInstructorScreen extends StatefulWidget {
  final Function(Instructor) onInstructorAdded;

  const AddInstructorScreen({super.key, required this.onInstructorAdded});

  @override
  _AddInstructorScreenState createState() => _AddInstructorScreenState();
}

class _AddInstructorScreenState extends State<AddInstructorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _roleController = TextEditingController();
  final _subjectController = TextEditingController();
  final _timeStartController = TextEditingController();
  final _timeEndController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Instructor')),
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
                controller: _roleController,
                decoration: const InputDecoration(labelText: 'Role'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a role';
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
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final instructor = Instructor(
                      _nameController.text,
                      _roleController.text,
                      Subject(
                        _subjectController.text,
                        _timeStartController.text,
                        _timeEndController.text,
                      ),
                    );
                    widget.onInstructorAdded(instructor);
                    Navigator.pop(context);
                  }
                },
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
    _roleController.dispose();
    _subjectController.dispose();
    _timeStartController.dispose();
    _timeEndController.dispose();
    super.dispose();
  }
}

// data_models.dart (or in the same file as AddInstructorScreen)
class Instructor {
  final String name;
  final String role;
  final Subject subject;
  String? remark;

  Instructor(this.name, this.role, this.subject, {this.remark});
}

class Subject {
  final String subject;
  final String timeStart;
  final String timeEnd;
  String? attendance;
  DateTime? attendanceTime;
  String? remark;
  DateTime? lateTime;

  Subject(this.subject, this.timeStart, this.timeEnd,
      {this.attendance, this.attendanceTime, this.remark, this.lateTime});
}