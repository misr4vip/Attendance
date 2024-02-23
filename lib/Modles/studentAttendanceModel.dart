class StudentAttendanceModel {
  String studentId = " ";
  String status = " ";
  int lateTime = 0;
  StudentAttendanceModel.m();
  StudentAttendanceModel.n(this.studentId, this.status, this.lateTime);
  toDictionary() {
    return {"studentId": studentId, "status": status, "lateTime": lateTime};
  }

  StudentAttendanceModel.z(Map value) {
    studentId = value['studentId'] as String;
    status = value['status'] as String;
    lateTime = value['lateTime'] as int;
  }
}
