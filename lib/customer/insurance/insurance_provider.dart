import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/models/insurance.dart';

class InsuranceProvider extends ChangeNotifier {
  final String uid;
  List<Insurance> insuranceList = [];

  InsuranceProvider({required this.uid}) {
    getData();
  }

  Future<void> getData() async {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('users').doc(uid).collection('insurances');
    QuerySnapshot querySnapshot = await collectionRef.get();

    // Get data from docs and convert map to List
    insuranceList = querySnapshot.docs
        .map((doc) => Insurance(
            vehicleId: doc['vehicleId'],
            accident: doc['accident'],
            paymentDate: doc['paymentDate']?.toDate(),
            selectedOffer: doc['selectedOffer'] != null
                ? InsuranceOffer.oferrsList
                    .firstWhere((offer) => offer.name == doc['selectedOffer'])
                : null,
            status: Status.getValueFromLabel(doc['status'])))
        .toList();

    notifyListeners();
  }

  Future<void> addInsurance(Insurance insurance) async {
    insuranceList.add(insurance);
    await _setFirebase(insurance);
    notifyListeners();
  }

  Future<void> removeInsurance(Insurance insurance) async {
    insuranceList.removeWhere((ins) => ins.vehicleId == insurance.vehicleId);
    await _removeFirebase(insurance);
    notifyListeners();
  }

  Future<void> updateInsurance(Insurance insurance) async {
    int index =
        insuranceList.indexWhere((ins) => ins.vehicleId == insurance.vehicleId);
    if (index != -1) {
      insuranceList[index] = insurance;
      await _setFirebase(insurance);
      notifyListeners();
    }
  }

  Future<void> _setFirebase(Insurance insurance) async {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('users').doc(uid).collection('insurances');

    await collectionRef.doc(insurance.vehicleId).set({
      'vehicleId': insurance.vehicleId,
      'accident': insurance.accident,
      'paymentDate': insurance.paymentDate,
      'selectedOffer': insurance.selectedOffer?.name,
      'status': insurance.status.label
    });
  }

  Future<void> _removeFirebase(Insurance insurance) async {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('users').doc(uid).collection('insurances');

    await collectionRef.doc(insurance.vehicleId).delete();
  }
}
