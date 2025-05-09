import 'package:age_calculator/age_calculator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_project/models/insurance.dart';
import 'package:ulid/ulid.dart';

class Vehicle {
  late String id;
  String customerName;
  String carModel;
  String chassisNumber;
  int manuYear;
  String regNumber;
  int passengers;
  DateTime driverBirth;
  double carPrice;
  Insurance? insurance;

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
      required this.carPrice,
      insured,
      renewal}) {
    this.id = id ?? Ulid().toCanonical();
  }

  Status get insuranceStatus {
    if (insurance != null) {
      return insurance!.status;
    }

    return Status.notInsured;
  }

  // Calculate driver's age from birth date
  int driverAge() {
    return AgeCalculator.age(driverBirth).years;
  }

  // Calculate current car price
  double carPriceNow() {
    int years = DateTime.now().year - this.manuYear;

    if (years > 8) {
      return (carPrice - carPrice * 0.8);
    }

    return (carPrice - carPrice * years * 0.1);
  }

  static Future<Vehicle> getVehicle(String id) async {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('vehicles').doc(id).get();

    return Vehicle(
        id: doc['id'],
        customerName: doc['customerName'],
        carModel: doc['carModel'],
        chassisNumber: doc['chassisNumber'],
        manuYear: doc['manuYear'],
        regNumber: doc['regNumber'],
        passengers: doc['passengers'],
        driverBirth: doc['driverBirth'].toDate(),
        carPrice: doc['carPrice']);
  }
}
