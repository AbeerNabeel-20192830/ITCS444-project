import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_project/admin/insurance/insurance_request_deatils.dart';
import 'package:flutter_project/components/pushed_page_scaffold.dart';
import 'package:flutter_project/models/insurance_provider.dart';
import 'package:flutter_project/models/insurance.dart';
import 'package:flutter_project/models/vehicle_provider.dart';
import 'package:provider/provider.dart';

class InsuranceRequestList extends StatefulWidget {
  const InsuranceRequestList({super.key});

  @override
  State<InsuranceRequestList> createState() => _InsuranceRequestListState();
}

class _InsuranceRequestListState extends State<InsuranceRequestList> {
  @override
  Widget build(BuildContext context) {
    
    if (context.watch<VehicleProvider>().isLoading ||
        context.watch<InsuranceProvider>().isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    List<Insurance> insuranceList = context
        .watch<InsuranceProvider>()
        .insuranceList
        .where((ins) => ins.status == Status.pendingApproval)
        .toList();

    // Show message if empty
    if (insuranceList.isEmpty) {
      return Center(
        child: Text(
          'No insurance requests found',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
        itemCount: insuranceList.length,
        shrinkWrap: true,
        itemBuilder: (context, i) {
          Insurance insurance = insuranceList[i];
          inspect(insurance);
          return Card(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8, left: 4, top: 4),
              child: ListTile(
                title: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  children: [
                    Text(insurance.vehicle?.chassisNumber ?? ''),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      color: Theme.of(context).highlightColor,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4, right: 4),
                        child: Text(
                          insurance.vehicle?.regNumber ?? '',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
                trailing: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PushedPageScaffold(
                                page: InsuranceRequestDetails(
                                  insurance: insurance,
                                ),
                                title:
                                    "${insurance.vehicle?.chassisNumber ?? ''} Request Details")));
                  },
                  child: Text(
                    "Review Request",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Customer Name: ${insurance.vehicle?.customerName}"),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      color: insurance.vehicle?.insuranceStatus.color,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 12,
                          right: 12,
                          top: 4,
                          bottom: 4,
                        ),
                        child: Text(
                          insurance.vehicle?.insuranceStatus.label ?? '',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                    )
                  ],
                ),
                titleAlignment: ListTileTitleAlignment.top,
                titleTextStyle: Theme.of(context).textTheme.titleSmall,
                subtitleTextStyle: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          );
        });
  }
}
