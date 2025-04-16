import 'package:flutter/material.dart';
import 'package:flutter_project/vehicle/vehicle.dart';

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
    return const Placeholder();
  }
}
