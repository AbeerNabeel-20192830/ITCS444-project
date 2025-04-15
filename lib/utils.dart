const double maxWidth = 1000;

// Regular expression
final alphaRegex = RegExp(r'^[a-zA-Z\s\.\-]+$');

final alphanumericRegex = RegExp(r'^[a-zA-Z0-9\s\-]+$');

// Converts DateTime to String
String dateToString(DateTime date) {
  return '${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
