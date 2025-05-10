import 'package:flutter/material.dart';
import 'package:flutter_project/customer/vehicle/vehicle_form.dart';

class NewVehiclePage extends StatefulWidget {
  const NewVehiclePage({super.key});

  @override
  State<NewVehiclePage> createState() => _NewVehiclePageState();
}

class _NewVehiclePageState extends State<NewVehiclePage> {
  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: VehicleForm(
          formType: FormType.create,
        ),
      ),
    );
  }
}
