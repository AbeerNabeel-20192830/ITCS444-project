import 'package:flutter/material.dart';
import 'package:flutter_project/components/quotation_card.dart';
import 'package:flutter_project/components/vehicle_information_card.dart';
import 'package:flutter_project/models/insurance.dart';
import 'package:flutter_project/models/vehicle.dart';

class InsuredPage extends StatefulWidget {
  static const title = 'Insurance Details';
  Vehicle vehicle;
  InsuredPage({super.key, required this.vehicle});

  @override
  State<InsuredPage> createState() => _InsuredPageState();
}

class _InsuredPageState extends State<InsuredPage> {
  @override
  Widget build(BuildContext context) {
    Insurance insurance = widget.vehicle.insurance!;

    return Column(
      spacing: 10,
      children: [
        vehicleInformationCard(context, insurance.vehicle!),
        quotationCard(context, insurance),
      ],
    );
  }
}
