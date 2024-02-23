class MyDate {
  /*
  convert string date and string time to date time 
  date is in format dd/mm/yyyy
  time is in format hh:mm 00
   */
  DateTime convertStringDateToDateTime(String date, String time) {
    int dayIndex = date.indexOf("/");
    int montIndex = date.indexOf("/", dayIndex + 1);
    int yearIndex = date.lastIndexOf("/");
    int count = date.length;
    int day = int.parse(date.substring(0, dayIndex));
    int month = int.parse(date.substring(dayIndex + 1, montIndex));
    int year = int.parse(date.substring(yearIndex + 1, count));

    int hourIndex = time.indexOf(":");
    int minuteIndex = time.indexOf(" ");
    int hour = int.parse(time.substring(0, hourIndex));
    int minute = int.parse(time.substring(hourIndex + 1, minuteIndex));
    String timeDayOrNight = time.substring(minuteIndex + 1);
    if (timeDayOrNight == "PM") {
      hour += 12;
    }
    DateTime myDateTime = DateTime(year, month, day, hour, minute);
    return myDateTime;
  }

/*
    comapre datetime to another datetime with start time and end time 
    return true if inside start and end time 
    else return false
*/
  bool compareDateTimeWithToday(
      String date1, String startTime, String endTime) {
    DateTime sessionStartDateTime =
        convertStringDateToDateTime(date1, startTime);

    DateTime sessionEndDateTime = convertStringDateToDateTime(date1, endTime);

    DateTime myDateTime = DateTime.now();
    if (myDateTime.compareTo(sessionEndDateTime) < 0 &&
        myDateTime.compareTo(sessionStartDateTime) >= 0) {
      return true;
    } else {
      return false;
    }
  }
}
