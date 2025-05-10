import 'package:flutter/material.dart';
import 'package:flutter_project/customer/vehicle/vehicle_list_view.dart';

class MyVehiclesPage extends StatefulWidget {
  const MyVehiclesPage({super.key});

  @override
  State<MyVehiclesPage> createState() => _MyVehiclesPageState();
}

class _MyVehiclesPageState extends State<MyVehiclesPage> {
  @override
  Widget build(BuildContext context) {
    return VehicleListView();
  }
}
