import 'package:flutter/material.dart';
import 'package:flutter_project/vehicle/vehicle_list_view.dart';

class MyVehiclesPage extends StatefulWidget {
  const MyVehiclesPage({super.key});

  @override
  State<MyVehiclesPage> createState() => _MyVehiclesPageState();
}

class _MyVehiclesPageState extends State<MyVehiclesPage> {
  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return VehicleListView(
      notifyParent: refresh,
    );
  }
}
