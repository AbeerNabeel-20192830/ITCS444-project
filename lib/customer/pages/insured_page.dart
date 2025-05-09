import 'package:flutter/material.dart';
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
    return const Placeholder();
  }
}
