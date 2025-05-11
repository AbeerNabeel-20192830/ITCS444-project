import 'package:flutter/material.dart';
import 'package:flutter_project/admin/pages/offers_page.dart';
import 'package:flutter_project/admin/pages/requests_page.dart';
import 'package:flutter_project/components/custom_appbar.dart';
import 'package:flutter_project/models/insurance.dart';
import 'package:flutter_project/models/insurance_provider.dart';
import 'package:flutter_project/models/vehicle.dart';
import 'package:flutter_project/models/vehicle_provider.dart';
import 'package:flutter_project/settings_page.dart';
import 'package:flutter_project/utils.dart';
import 'package:provider/provider.dart';

class AdminView extends StatefulWidget {
  const AdminView({super.key});

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  var title = '';
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        title = 'Insurance Requests';
        page = const InsuranceRequestsPage();
        break;
      case 1:
        title = 'Accident Reports';
        page = const Placeholder();
        break;
      case 2:
        title = 'Offers';
        page = const OffersPage();
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
              icon: Icon(Icons.request_page), label: 'Insurance Requests'),
          NavigationDestination(
              icon: Icon(Icons.car_crash), label: 'Accident Reports'),
          NavigationDestination(
              icon: Icon(Icons.monetization_on), label: 'Offers'),
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
