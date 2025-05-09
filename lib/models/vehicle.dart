import 'dart:developer';
import 'package:age_calculator/age_calculator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ulid/ulid.dart';

class Vehicle extends ChangeNotifier {
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

  // Static list to hold vehicle data
  static List<Vehicle> vehicleList = [];

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

  // Get data from Firebase and set to vehicleList
  static Future<void> getData() async {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('vehicles');
    QuerySnapshot querySnapshot = await collectionRef.get();

    // Get data from docs and convert map to List
    vehicleList = querySnapshot.docs
        .map((doc) => Vehicle(
            id: doc['id'],
            customerName: doc['customerName'],
            carModel: doc['carModel'],
            chassisNumber: doc['chassisNumber'],
            manuYear: doc['manuYear'],
            regNumber: doc['regNumber'],
            passengers: doc['passengers'],
            driverBirth: doc['driverBirth'].toDate(),
            carPrice: doc['carPrice']))
        .toList();

    inspect(vehicleList);
  }

  // CRUD operations
  Future<void> addVehicle() async {
    vehicleList.add(this);
    await _setFirebase(this);
    notifyListeners();
  }

  Future<void> removeVehicle() async {
    vehicleList.removeWhere((v) => v.id == this.id);
    await _removeFirebase(this);
    notifyListeners();
  }

  Future<void> updateVehicle() async {
    int index = vehicleList.indexWhere((v) => v.id == this.id);
    if (index != -1) {
      vehicleList[index] = this;
      await _setFirebase(this);
      notifyListeners();
    }
  }

  Future<void> _setFirebase(Vehicle vehicle) async {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('vehicles');

    await collectionRef.doc(vehicle.id).set({
      'id': vehicle.id,
      'customerName': vehicle.customerName,
      'carModel': vehicle.carModel,
      'chassisNumber': vehicle.chassisNumber,
      'manuYear': vehicle.manuYear,
      'regNumber': vehicle.regNumber,
      'passengers': vehicle.passengers,
      'driverBirth': vehicle.driverBirth,
      'carPrice': vehicle.carPrice
    });
  }

  Future<void> _removeFirebase(Vehicle vehicle) async {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('vehicles');

    await collectionRef.doc(vehicle.id).delete();
  }
}
