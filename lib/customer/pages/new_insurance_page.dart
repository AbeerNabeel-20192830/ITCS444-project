import 'package:flutter/material.dart';
import 'package:flutter_project/insurance/insurance_request_form.dart';

class NewInsurancePage extends StatefulWidget {
  static const title = 'New Insurance';
  const NewInsurancePage({super.key});

  @override
  State<NewInsurancePage> createState() => _NewInsurancePageState();
}

class _NewInsurancePageState extends State<NewInsurancePage> {
  @override
  Widget build(BuildContext context) {
    return InsuranceRequestForm();
  }
}
