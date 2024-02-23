class SessionModel {
  String courseid = " ";
  String sessionDate = " ";
  String sessionStartTime = " ";
  String sessionId = "";
  String sessionEndtime = "";

  SessionModel.m();
  SessionModel.n(this.courseid, this.sessionDate, this.sessionStartTime,
      this.sessionEndtime, this.sessionId);
  toDictionary() {
    return {
      "courseid": courseid,
      "sessionDate": sessionDate,
      "sessionStartTime": sessionStartTime,
      "sessionEndtime": sessionEndtime,
      "sessionId": sessionId
    };
  }

  SessionModel.z(Map value) {
    courseid = value['courseid'] as String;
    sessionDate = value['sessionDate'] as String;
    sessionStartTime = value['sessionStartTime'] as String;
    sessionEndtime = value['sessionEndtime'] as String;
    sessionId = value['sessionId'] as String;
  }
}
