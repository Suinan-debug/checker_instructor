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
