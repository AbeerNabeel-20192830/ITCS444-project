import 'package:age_calculator/age_calculator.dart';
import 'package:ulid/ulid.dart';

class Vehicle {
  String id;
  String customerName;
  String carModel;
  String chassisNumber;
  int manuYear;
  String regNumber;
  int passengers;
  DateTime driverBirth;
  double carPrice;
  bool insured = false;
  bool renewal = false;

  // Constructor
  Vehicle(
      {id,
      required this.customerName,
      required this.carModel,
      required this.chassisNumber,
      required this.manuYear,
      required this.regNumber,
      required this.passengers,
      required this.driverBirth,
      required this.carPrice})
      : this.id = id ?? Ulid().toCanonical();

  // Calculate driver's age from birth date
  int driverAge() {
    return AgeCalculator.age(driverBirth).years;
  }

  // Calculate current car price
  double carPriceNow() {
    int years = DateTime.now().year - this.manuYear;
    return (this.carPrice * years * 0.1);
  }
}
