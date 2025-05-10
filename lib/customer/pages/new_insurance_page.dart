import 'package:flutter/material.dart';
import 'package:flutter_project/customer/insurance/insurance_request_form.dart';
import 'package:flutter_project/models/vehicle.dart';

class NewInsurancePage extends StatefulWidget {
  static const title = 'New Insurance';
  Vehicle vehicle;
  NewInsurancePage({super.key, required this.vehicle});

  @override
  State<NewInsurancePage> createState() => _NewInsurancePageState();
}

class _NewInsurancePageState extends State<NewInsurancePage> {
  @override
  Widget build(BuildContext context) {
    return InsuranceRequestForm(
      vehicle: widget.vehicle,
    );
  }
}
