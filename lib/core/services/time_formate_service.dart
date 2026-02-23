import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TimeFormateService {
  String formatDate(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return DateFormat('dd-MM-yyyy').format(date);
  }

  // ------------ Get formatted time ---------------

  String getFormattedTime(String slotStart) {
    DateTime utcTime = DateTime.parse(slotStart); // parse UTC time
    DateTime localTime = utcTime.toLocal(); // convert to device timezone

    return DateFormat('hh:mm a').format(localTime);
  }
}
