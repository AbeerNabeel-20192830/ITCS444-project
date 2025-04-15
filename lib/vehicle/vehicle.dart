import 'dart:convert';
import 'package:flutter_project/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ulid/ulid.dart';

class Vehicle {
  Ulid id;
  String customerName;
  String carModel;
  String chassisNumber;
  DateTime manuYear;
  String regNumber;
  int passengersNum;
  DateTime driverBirth;
  double carPrice;

  static List<Vehicle> vehicleList = [];

  Vehicle(
      {id,
      required this.customerName,
      required this.carModel,
      required this.chassisNumber,
      required this.manuYear,
      required this.regNumber,
      required this.passengersNum,
      required this.driverBirth,
      required this.carPrice})
      : this.id = id ?? Ulid();

  Future<void> addToLocal({id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    id = id ?? this.id;

    Map<String, dynamic> vehicleMap = {
      'customerName': customerName,
      'carModel': carModel,
      'chassisNumber': chassisNumber,
      'manuYear': dateToString(manuYear),
      'regNumber': regNumber,
      'passengersNum': passengersNum,
      'driverBirth': dateToString(driverBirth),
      'carPrice': carPrice
    };

    String vehicleJSON = jsonEncode(vehicleMap);
    prefs.setString(id.toCanonical(), vehicleJSON);
  }

  Future<void> removeFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(id.toCanonical());
  }

  Future<void> updateInLocal() async {
    removeFromLocal();
    addToLocal();
  }

  static Future<void> loadFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    keys.remove('isDarkMode');
    final prefsMap = <String, dynamic>{};

    for (String key in keys) {
      prefsMap[key] = prefs.get(key);
      final vehicleMap = jsonDecode(prefsMap[key]);

      Vehicle vehicle = Vehicle(
          customerName: vehicleMap['customerName'],
          carModel: vehicleMap['carModel'],
          chassisNumber: vehicleMap['chassisNumber'],
          manuYear: DateTime.parse(vehicleMap['manuYear']),
          regNumber: vehicleMap['regNumber'],
          passengersNum: vehicleMap['passengersNum'],
          driverBirth: DateTime.parse(vehicleMap['driverBirth']),
          carPrice: vehicleMap['carPrice']);

      if (!Vehicle.vehicleList.contains(vehicle)) {
        Vehicle.vehicleList.add(vehicle);
      }
    }
  }
}
