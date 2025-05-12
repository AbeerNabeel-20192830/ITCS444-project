import 'package:flutter/material.dart';
import 'package:flutter_project/models/accident.dart';
import 'package:flutter_project/models/accident_provider.dart';
import 'package:flutter_project/models/vehicle.dart';
import 'package:flutter_project/models/vehicle_provider.dart';
import 'package:flutter_project/utils.dart';
import 'package:provider/provider.dart';

class AdminAccidentPage extends StatefulWidget {
  const AdminAccidentPage({super.key});

  @override
  State<AdminAccidentPage> createState() => _AdminAccidentPageState();
}

class _AdminAccidentPageState extends State<AdminAccidentPage> {
  String? searchKeyword;
  List<Accident> filteredAccidents = [];

  List<Accident> filterAccidentList(List<Accident> accidentList) {
    return accidentList.where((accident) {
      searchKeyword = searchKeyword?.toLowerCase();

      final match = searchKeyword == null ||
          accident.damagedParts.toLowerCase().contains(searchKeyword!) ||
          accident.repairCost.toString().contains(searchKeyword!) ||
          dateToString(accident.accidentDate)
              .toLowerCase()
              .contains(searchKeyword!);
      return match;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<Accident> accidentList =
        context.watch<AccidentProvider>().accidentList;

    List<Vehicle> vehcileList = context.watch<VehicleProvider>().vehicleList;

    if (context.read<AccidentProvider>().isLoading ||
        context.read<VehicleProvider>().isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    filteredAccidents = filterAccidentList(accidentList);

    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(
              labelText: 'Search', prefixIcon: Icon(Icons.search)),
          onChanged: (value) => setState(() => searchKeyword = value),
        ),
        const SizedBox(height: 20),
        filteredAccidents.isEmpty
            ? const Center(child: Text("No matching records"))
            : ListView.builder(
                shrinkWrap: true,
                itemCount: filteredAccidents.length,
                itemBuilder: (context, i) {
                  Accident accident = filteredAccidents[i];
                  Vehicle vehicle =
                      vehcileList.firstWhere((v) => v.id == accident.vehicleId);

                  return Card(
                    child: ListTile(
                      title: Text(
                        'Vehicle Registration Number: ${vehicle.regNumber}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Accident Date: ${dateToString(accident.accidentDate)}',
                          ),
                          Text('Damaged Parts: ${accident.damagedParts}'),
                          Text('Repair Cost: ${accident.repairCost} BHD'),
                          Text(
                              'Consumption Rate: ${accident.consumptionRate * 100}%'),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ],
    );
  }
}
