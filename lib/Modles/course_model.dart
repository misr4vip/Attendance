class CourseModel {
  String courseid = " ";
  String courseName = " ";
  String doctorId = " ";
  String semsterId = " ";
  String classId = "";

  CourseModel.m();
  CourseModel.n(this.courseid, this.courseName, this.doctorId, this.semsterId,
      this.classId);
  toDictionary() {
    return {
      "courseid": courseid,
      "courseName": courseName,
      "doctorId": doctorId,
      "semsterId": semsterId,
      "classId": classId
    };
  }

  CourseModel.z(Map value) {
    courseid = value['courseid'] as String;
    courseName = value['courseName'] as String;
    doctorId = value['doctorId'] as String;
    semsterId = value['semsterId'] as String;
    classId = value['classId'] as String;
  }
}
