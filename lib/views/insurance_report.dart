import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_project/models/insurance.dart';
import 'package:flutter_project/models/vehicle.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_project/theme/theme.dart';
import 'package:intl/intl.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;
  ThemeData _themeData;

  ThemeData get themeData => _themeData;
  bool get isDarkMode => _isDarkMode;

  ThemeProvider() : _themeData = lightMode {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _themeData = _isDarkMode ? darkMode : lightMode;
    notifyListeners();
  }

  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    _themeData = _isDarkMode ? darkMode : lightMode;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);

    notifyListeners();
  }
}

class InsuranceReportView extends StatefulWidget {
  const InsuranceReportView({super.key});

  @override
  State<InsuranceReportView> createState() => _InsuranceReportViewState();
}

class _InsuranceReportViewState extends State<InsuranceReportView> {
  String? registrationFilter;
  int? yearFilter;

  Future<List<Insurance>> fetchInsuranceList() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('insurance').get();
    List<Insurance> insuranceList = [];

    for (var doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data();
      final vehicle = await Vehicle.getVehicle(data['vehicleId']);

      final insurance = Insurance(
        vehicleId: data['vehicleId'],
        accident: data['accident'] ?? false,
        paymentDate: (data['paymentDate'] as Timestamp?)?.toDate(),
        startDate: (data['startDate'] as Timestamp?)?.toDate(),
        endDate: (data['endDate'] as Timestamp?)?.toDate(),
        status: Status.getValueFromLabel(data['status'] ?? 'Pending approval'),
        policyId: data['policyId'],
        finalPrice: data['finalPrice']?.toDouble(),
        vehicle: vehicle,
      );

      insuranceList.add(insurance);
    }

    return insuranceList;
  }

  List<Insurance> filterInsuranceList(List<Insurance> list) {
    return list.where((insurance) {
      final matchesRegistration = registrationFilter == null ||
          insurance.vehicle?.regNumber.contains(registrationFilter!) == true;
      final matchesYear =
          yearFilter == null || insurance.startDate?.year == yearFilter;
      return matchesRegistration && matchesYear;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Insurance Policy Report')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
//search - filters
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration:
                        const InputDecoration(labelText: 'Registration Number'),
                    onChanged: (value) =>
                        setState(() => registrationFilter = value),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(labelText: 'Year'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) =>
                        setState(() => yearFilter = int.tryParse(value)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

//Firestore
            Expanded(
              child: FutureBuilder<List<Insurance>>(
                future: fetchInsuranceList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text("Error loading data"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text("No insurance records found"));
                  }

                  final filtered = filterInsuranceList(snapshot.data!);

                  return filtered.isEmpty
                      ? const Center(child: Text("No matching records"))
                      : ListView.builder(
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final insurance = filtered[index];
                            return Card(
                              child: ListTile(
                                title: Text(
                                  insurance.vehicle?.regNumber ??
                                      'Unknown Vehicle',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  'Start: ${DateFormat.yMMMd().format(insurance.startDate ?? DateTime(0))}\n'
                                  'End: ${DateFormat.yMMMd().format(insurance.endDate ?? DateTime(0))}\n'
                                  'Status: ${insurance.status.label}',
                                ),
                              ),
                            );
                          },
                        );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final themeProvider =
              Provider.of<ThemeProvider>(context, listen: false);
          themeProvider.toggleTheme();
        },
        child: Icon(Icons.brightness_6),
      ),
    );
  }
}
