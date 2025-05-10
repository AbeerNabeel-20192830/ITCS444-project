
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/models/insurance.dart';

class OfferProvider extends ChangeNotifier {
  bool isLoading = true;

  // some pre-made offers
  List<InsuranceOffer> offerList = [];

  OfferProvider() {
    getData();
  }

  Future<void> getData() async {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('offers');
    QuerySnapshot querySnapshot = await collectionRef.get();

    // Get data from docs and convert map to List
    offerList = querySnapshot.docs.map((doc) {
      return InsuranceOffer(
        name: doc['name'],
        price: doc['price'],
        features: List<String>.from(doc['features'] ?? []),
      );
    }).toList();

    isLoading = false;
    notifyListeners();
  }

  Future<void> addOffer(InsuranceOffer offer) async {
    offerList.add(offer);
    await _setFirebase(offer);
    notifyListeners();
  }

  Future<void> removeOffer(InsuranceOffer offer) async {
    offerList.removeWhere((o) => o.name == offer.name);
    await _removeFirebase(offer);
    notifyListeners();
  }

  Future<void> updateOffer(InsuranceOffer offer) async {
    int index = offerList.indexWhere((o) => o.name == offer.name);
    if (index != -1) {
      offerList[index] = offer;
      await _setFirebase(offer);
      notifyListeners();
    }
  }

  Future<void> _setFirebase(InsuranceOffer offer) async {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('offers');

    await collectionRef.doc(offer.name).set({
      'name': offer.name,
      'price': offer.price,
      'features': offer.features,
    });
  }

  Future<void> _removeFirebase(InsuranceOffer offer) async {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('offers');

    await collectionRef.doc(offer.name).delete();
  }
}
