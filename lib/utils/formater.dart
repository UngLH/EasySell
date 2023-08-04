import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Formater {
  static String AppDateFormat(DateTime date) {
    String formattedDate = DateFormat('dd-MM-yyyy').format(date);
    return formattedDate;
  }
}
