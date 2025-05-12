import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/models/accident.dart';

class AccidentProvider extends ChangeNotifier {
  String uid;
  final bool isAdmin;
  bool isLoading = true;
  List<Accident> accidentList = [];

  AccidentProvider({required this.uid, required this.isAdmin}) {
    if (isAdmin) {
      getAllData();
    } else {
      getUserData();
    }
  }

  Future<void> getAllData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collectionGroup('vehicles').get();

    // Get data from docs and convert map to List
    accidentList = querySnapshot.docs.map((doc) {
      String path = doc.reference.path;
      List<String> segments = path.split('/');
      this.uid = segments[1];

      return Accident(
          uid: uid,
          vehicleId: doc['vehicleId'],
          accidentDate: doc['accidentDate'],
          damagedParts: doc['damagedParts'],
          repairCost: doc['repairCost'],
          consumptionRate: doc['consumptionRate']);
    }).toList();

    isLoading = false;
    notifyListeners();
  }

  Future<void> getUserData() async {
    CollectionReference collectionRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('accidents');
    QuerySnapshot querySnapshot = await collectionRef.get();

    // Get data from docs and convert map to List
    accidentList = querySnapshot.docs.map((doc) {
      return Accident(
          uid: uid,
          vehicleId: doc['vehicleId'],
          accidentDate: doc['accidentDate'].toDate(),
          damagedParts: doc['damagedParts'],
          repairCost: doc['repairCost'],
          consumptionRate: doc['consumptionRate']);
    }).toList();

    isLoading = false;
    notifyListeners();
  }

  Future<void> addAccident(Accident accident) async {
    accidentList.add(accident);
    await _setFirebase(accident);
    notifyListeners();
  }

  Future<void> _setFirebase(Accident accident) async {
    CollectionReference collectionRef = FirebaseFirestore.instance
        .collection('users')
        .doc(accident.uid ?? uid)
        .collection('accidents');

    await collectionRef.doc().set({
      'vehicleId': accident.vehicleId,
      'accidentDate': accident.accidentDate,
      'damagedParts': accident.damagedParts,
      'repairCost': accident.repairCost,
      'consumptionRate': accident.consumptionRate,
    });
  }
}
