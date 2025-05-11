import 'package:flutter/material.dart';
import 'package:flutter_project/components/quotation_card.dart';
import 'package:flutter_project/components/vehicle_information_card.dart';
import 'package:flutter_project/models/insurance.dart';
import 'package:flutter_project/models/insurance_provider.dart';
import 'package:flutter_project/models/vehicle.dart';
import 'package:provider/provider.dart';

class RenewalPage extends StatefulWidget {
  static const title = 'Insurance Renewal';
  Vehicle vehicle;
  RenewalPage({super.key, required this.vehicle});

  @override
  State<RenewalPage> createState() => _RenewalPageState();
}

class _RenewalPageState extends State<RenewalPage> {
  @override
  Widget build(BuildContext context) {
    Insurance insurance = widget.vehicle.insurance!;

    return Column(
      spacing: 10,
      children: [
        vehicleInformationCard(context, insurance.vehicle!),
        quotationCard(context, insurance),
        ElevatedButton(
            onPressed: () {
              insurance.pay();
              context.read<InsuranceProvider>().updateInsurance(insurance);
              Navigator.of(context).pop();
            },
            child: Text('Pay'))
      ],
    );
  }
}
