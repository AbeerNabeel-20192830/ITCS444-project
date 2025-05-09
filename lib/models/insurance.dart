import 'package:flutter/material.dart';
import 'package:flutter_project/models/vehicle.dart';

enum Status {
  notInsured('Not insured', Colors.red),
  pendingApproval('Pending approval', Colors.amber),
  notPayed('Not payed', Colors.deepOrangeAccent),
  payed('Payed', Colors.green);

  const Status(this.label, this.color);

  final String label;
  final Color color;

  static Status getValueFromLabel(String label) {
    switch (label) {
      case 'Not insured':
        return Status.notInsured;
      case 'Pending approval':
        return Status.pendingApproval;
      case 'Not payed':
        return Status.notPayed;
      case 'Payed':
        return Status.payed;
    }

    return Status.pendingApproval;
  }
}

// one insurance object is associated with one vehicle
class Insurance {
  String vehicleId;
  bool accident;
  DateTime? paymentDate;
  InsuranceOffer? selectedOffer;
  Vehicle? vehicle;
  Status status;

  Insurance(
      {required this.vehicleId,
      this.selectedOffer,
      this.accident = false,
      this.paymentDate,
      this.vehicle,
      this.status = Status.pendingApproval});

  price() {
    if (selectedOffer != null) {
      return selectedOffer!.price;
    }

    int ageAddon =
        vehicle!.driverAge() < 24 ? 10 : 0; // 10 BD extra if younger than 24
    int accidentAddon = accident ? 20 : 0; // 20 BD extra if accident

    return (vehicle!.carPriceNow() / 100) + ageAddon + accidentAddon;
  }

  approve() {
    status = Status.notPayed;
  }

  static double estimatePrice(Vehicle vehicle, bool accident) {
    int ageAddon = vehicle.driverAge() < 24 ? 10 : 0;
    int accidentAddon = accident ? 20 : 0;
    return (vehicle.carPriceNow() / 100) + ageAddon + accidentAddon;
  }

  void pay() {
    status = Status.payed;
    paymentDate = DateTime.now();
  }

  DateTime? nextPaymentDate() {
    if (paymentDate != null) {
      return DateTime(
          paymentDate!.year + 1, paymentDate!.month, paymentDate!.day);
    }
    return null;
  }
}

// For admin to create insurance offers
class InsuranceOffer {
  String name;
  double price;
  List<String>? features;

  // must be empty and added from isurance_offer_form
  static List<InsuranceOffer> oferrsList = [
    InsuranceOffer(
        name: 'Regular',
        price: 80,
        features: ['No road assist', 'Up to 1000 BHD in damages']),
    InsuranceOffer(
        name: 'Premium',
        price: 150,
        features: ['Road assist', 'Up to 5000 BHD in damages']),
    InsuranceOffer(name: 'Enterprise', price: 250, features: [
      'Road assist',
      'Up to 10000 BHD in damages',
      'Insurance covers up to 10 vehicles'
    ]),
  ];

  InsuranceOffer({required this.name, required this.price, this.features});
}
