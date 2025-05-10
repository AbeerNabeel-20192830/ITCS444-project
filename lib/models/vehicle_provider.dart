import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/models/vehicle.dart';

class VehicleProvider extends ChangeNotifier {
  final String uid;
  bool isLoading = true;
  List<Vehicle> vehicleList = [];

  VehicleProvider({required this.uid}) {
    getData();
  }

  Future<void> getData() async {
    CollectionReference collectionRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('vehicles');
    QuerySnapshot querySnapshot = await collectionRef.get();

    // Get data from docs and convert map to List
    vehicleList = querySnapshot.docs.map((doc) {
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
    }).toList();

    isLoading = false;
    notifyListeners();
  }

  Future<void> addVehicle(Vehicle vehicle) async {
    vehicleList.add(vehicle);
    await _setFirebase(vehicle);
    notifyListeners();
  }

  Future<void> removeVehicle(vehicle) async {
    vehicleList.removeWhere((v) => v.id == vehicle.id);
    await _removeFirebase(vehicle);
    notifyListeners();
  }

  Future<void> updateVehicle(vehicle) async {
    int index = vehicleList.indexWhere((v) => v.id == vehicle.id);
    if (index != -1) {
      vehicleList[index] = vehicle;
      await _setFirebase(vehicle);
      notifyListeners();
    }
  }

  Future<void> _setFirebase(Vehicle vehicle) async {
    CollectionReference collectionRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('vehicles');

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
    CollectionReference collectionRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('vehicles');

    await collectionRef.doc(vehicle.id).delete();
  }
}
