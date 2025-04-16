import 'package:flutter_project/vehicle/vehicle.dart';

// one insurance object is associated with one vehicle
class Insurance {
  Vehicle vehicle;
  String id; // same as vehicle id
  InsuranceOffer? selectedOffer;
  bool _payed = false;
  DateTime? _paymentDate;
  DateTime? _nextPaymentDate;
  bool? accident;

  // all insurances, each unique to one vehicle
  static List<Insurance> insuranceList = [];

  Insurance({required this.vehicle, this.selectedOffer, required this.accident})
      : this.id = vehicle.id;

  double price() {
    if (selectedOffer != null) {
      return selectedOffer!.price;
    }

    int ageAddon =
        vehicle.driverAge() < 24 ? 10 : 0; // 10 BD extra if younger than 24
    int accidentAddon = accident! ? 20 : 0; // 20 BD extra if accident

    return (vehicle.carPriceNow() / 100) + ageAddon + accidentAddon;
  }

  static double estimatePrice(Vehicle vehicle, bool accident) {
    int ageAddon = vehicle.driverAge() < 24 ? 10 : 0;
    int accidentAddon = accident ? 20 : 0;
    return (vehicle.carPriceNow() / 100) + ageAddon + accidentAddon;
  }

  bool get payed => _payed;

  DateTime? get nextPaymentDate => _nextPaymentDate;

  void pay() {
    _payed = true;
    _paymentDate = DateTime.now();
    _nextPaymentDate = DateTime(_paymentDate!.year + 1, _paymentDate!.month,
        _paymentDate!.day); // next year
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
