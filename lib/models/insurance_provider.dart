import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/admin/offers/offer_provider.dart';
import 'package:flutter_project/models/insurance.dart';

class InsuranceProvider extends ChangeNotifier {
  String uid;
  final bool isAdmin;
  final OfferProvider offerProvider;
  bool isLoading = true;
  List<Insurance> insuranceList = [];

  InsuranceProvider({
    required this.uid,
    required this.isAdmin,
    required this.offerProvider,
  }) {
    if (isAdmin) {
      getAllData();
    } else {
      getUserData();
    }
  }

  Future<void> getAllData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collectionGroup('insurances').get();

    // Get data from docs and convert map to List
    insuranceList = querySnapshot.docs.map((doc) {
      // get user
      String path = doc.reference.path;
      List<String> segments = path.split('/');
      this.uid = segments[1];

      return Insurance(
          uid: uid,
          vehicleId: doc['vehicleId'],
          accident: doc['accident'],
          selectedOffer: doc['selectedOffer'] != null
              ? offerProvider.offerList
                  .firstWhere((offer) => offer.name == doc['selectedOffer'])
              : null,
          status: Status.getValueFromLabel(doc['status']),
          startDate: doc['startDate']?.toDate(),
          endDate: doc['endDate']?.toDate(),
          policyId: doc['policyId'],
          finalPrice: doc['finalPrice']);
    }).toList();

    isLoading = false;
    notifyListeners();
  }

  Future<void> getUserData() async {
    CollectionReference collectionRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('insurances');
    QuerySnapshot querySnapshot = await collectionRef.get();

    // Get data from docs and convert map to List
    insuranceList = querySnapshot.docs
        .map((doc) => Insurance(
            uid: uid,
            id: doc['id'],
            vehicleId: doc['vehicleId'],
            accident: doc['accident'],
            selectedOffer: doc['selectedOffer'] != null
                ? offerProvider.offerList
                    .firstWhere((offer) => offer.name == doc['selectedOffer'])
                : null,
            status: Status.getValueFromLabel(doc['status']),
            startDate: doc['startDate']?.toDate(),
            endDate: doc['endDate']?.toDate(),
            policyId: doc['policyId'],
            finalPrice: doc['finalPrice']))
        .toList();

    isLoading = false;
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
    CollectionReference collectionRef = FirebaseFirestore.instance
        .collection('users')
        .doc(insurance.uid ?? uid)
        .collection('insurances');

    await collectionRef.doc(insurance.id).set({
      'id': insurance.id,
      'vehicleId': insurance.vehicleId,
      'accident': insurance.accident,
      'selectedOffer': insurance.selectedOffer?.name,
      'status': insurance.status.label,
      'startDate': insurance.startDate,
      'endDate': insurance.endDate,
      'policyId': insurance.policyId,
      'finalPrice': insurance.finalPrice,
    });
  }

  Future<void> _removeFirebase(Insurance insurance) async {
    CollectionReference collectionRef = FirebaseFirestore.instance
        .collection('users')
        .doc(insurance.uid ?? uid)
        .collection('insurances');

    await collectionRef.doc(insurance.vehicleId).delete();
  }
}
