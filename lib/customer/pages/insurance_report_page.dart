import 'package:flutter/material.dart';
import 'package:flutter_project/models/insurance.dart';
import 'package:flutter_project/models/insurance_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class InsuranceReportPage extends StatefulWidget {
  const InsuranceReportPage({super.key});

  @override
  State<InsuranceReportPage> createState() => _InsuranceReportPageState();
}

class _InsuranceReportPageState extends State<InsuranceReportPage> {
  String? registrationFilter;
  int? yearFilter;

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
    List<Insurance> insuranceList =
        context.watch<InsuranceProvider>().insuranceList;

    final filtered = filterInsuranceList(insuranceList);

    return Column(
      children: [
        // search - filters
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

        filtered.isEmpty
            ? const Center(child: Text("No matching records"))
            : ListView.builder(
                shrinkWrap: true,
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final insurance = filtered[index];
                  return Card(
                    child: ListTile(
                      title: Text(
                        insurance.vehicle?.regNumber ?? 'Unknown Vehicle',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Insurad at: ${insurance.startDate != null ? DateFormat.yMMMd().format(insurance.startDate!) : '—'}\n'
                        'Expires at: ${insurance.endDate != null ? DateFormat.yMMMd().format(insurance.endDate!) : '—'}\n'
                        'Status: ${insurance.status.label}',
                      ),
                    ),
                  );
                },
              ),
      ],
    );
  }
}
