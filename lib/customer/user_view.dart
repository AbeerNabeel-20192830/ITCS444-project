import 'package:flutter/material.dart';
import 'package:flutter_project/components/custom_appbar.dart';
import 'package:flutter_project/customer/pages/insurance_report_page.dart';
import 'package:flutter_project/customer/pages/my_vehicles_page.dart';
import 'package:flutter_project/customer/pages/new_vehicle_page.dart';
import 'package:flutter_project/models/insurance.dart';
import 'package:flutter_project/models/insurance_provider.dart';
import 'package:flutter_project/models/vehicle.dart';
import 'package:flutter_project/models/vehicle_provider.dart';
import 'package:flutter_project/settings_page.dart';
import 'package:flutter_project/utils.dart';
import 'package:provider/provider.dart';

class UserView extends StatefulWidget {
  const UserView({super.key});

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  var title = '';
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        title = 'New Vehicle';
        page = const NewVehiclePage();
        break;
      case 1:
        title = 'My Vehicles';
        page = const MyVehiclesPage();
        break;
      case 2:
        title = 'My Insurances';
        page = const InsuranceReportPage();
        break;
      case 3:
        title = 'Settings';
        page = const SettingsPage();
        break;
      default:
        page = const Placeholder();
    }

    List<Vehicle> vehicleList = context.watch<VehicleProvider>().vehicleList;
    List<Insurance> insuranceList =
        context.watch<InsuranceProvider>().insuranceList;

    // initialize insuarances vehicles
    for (Insurance ins in insuranceList) {
      int index = vehicleList.indexWhere((v) => v.id == ins.vehicleId);
      if (index != -1) {
        ins.vehicle = context.watch<VehicleProvider>().vehicleList[index];
      } else {
        // if vehicle not found then delete insurance
        context.read<InsuranceProvider>().removeInsurance(ins);
      }
    }

    // initialize vehicles insurances
    for (Vehicle vehicle in vehicleList) {
      int index =
          insuranceList.indexWhere((ins) => vehicle.id == ins.vehicleId);
      if (index != -1) {
        vehicle.insurance =
            context.watch<InsuranceProvider>().insuranceList[index];
      }
    }

    return Scaffold(
      appBar: appBar(context, title),
      body: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: maxWidth,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: page,
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.add_circle), label: 'New Vehicle'),
          NavigationDestination(
              icon: Icon(Icons.directions_car), label: 'My Vehicles'),
          NavigationDestination(
              icon: Icon(Icons.policy), label: 'My Insurances'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        selectedIndex: selectedIndex,
        onDestinationSelected: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
      ),
    );
  }
}
