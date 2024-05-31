import 'package:intl/intl.dart';

String getCurrentDate() {
  var now = DateTime.now();
  var formatter = DateFormat('dd-MM-yyyy');
  String formattedDate = formatter.format(now);
  return formattedDate;
}
