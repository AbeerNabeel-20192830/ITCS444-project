import 'package:flutter/material.dart';
import 'package:flutter_project/models/vehicle.dart';
import 'package:ulid/ulid.dart';

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
  String? uid;
  late String id;
  String vehicleId;
  bool accident;
  DateTime? paymentDate;
  DateTime? startDate;
  DateTime? endDate;
  InsuranceOffer? selectedOffer;
  Vehicle? vehicle;
  Status status;
  String? policyId;
  double? finalPrice;

  Insurance({
    this.uid,
    id,
    required this.vehicleId,
    this.selectedOffer,
    this.accident = false,
    this.paymentDate,
    this.startDate,
    this.endDate,
    this.vehicle,
    this.status = Status.pendingApproval,
    this.policyId,
    this.finalPrice,
  }) {
    this.id = id ?? Ulid().toCanonical();
  }

  double price() {
    if (selectedOffer != null) {
      return selectedOffer!.price;
    }

    int ageAddon =
        vehicle!.driverAge() < 24 ? 10 : 0; // 10 BD extra if younger than 24
    int accidentAddon = accident ? 20 : 0; // 20 BD extra if accident

    return (vehicle!.carPriceNow() / 100) + ageAddon + accidentAddon;
  }

  void approve() {
    status = Status.notPayed;
    finalPrice = price();
  }

  static double estimatePrice(Vehicle vehicle, bool accident) {
    int ageAddon = vehicle.driverAge() < 24 ? 10 : 0;
    int accidentAddon = accident ? 20 : 0;
    return (vehicle.carPriceNow() / 100) + ageAddon + accidentAddon;
  }

  void pay() {
    status = Status.payed;
  }
}

// For admin to create insurance offers
class InsuranceOffer {
  String name;
  double price;
  List<String>? features;

  InsuranceOffer({required this.name, required this.price, this.features});
}
