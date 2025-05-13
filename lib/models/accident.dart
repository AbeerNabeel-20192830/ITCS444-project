class Accident {
  String? uid;
  String vehicleId;
  DateTime accidentDate;
  String damagedParts;
  double repairCost;
  double consumptionRate;

  Accident({
    this.uid,
    required this.vehicleId,
    required this.accidentDate,
    required this.damagedParts,
    required this.repairCost,
    required this.consumptionRate,
  });
}
