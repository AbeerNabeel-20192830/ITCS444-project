import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/components/custom_snackbar.dart';
import 'package:flutter_project/components/pushed_page_scaffold.dart';
import 'package:flutter_project/customer/pages/insured_page.dart';
import 'package:flutter_project/customer/pages/new_insurance_page.dart';
import 'package:flutter_project/customer/pages/renewal_page.dart';
import 'package:flutter_project/models/insurance.dart';
import 'package:flutter_project/customer/insurance/insurance_provider.dart';
import 'package:flutter_project/customer/vehicle/vehicle_provider.dart';
import 'package:flutter_project/utils.dart';
import 'package:flutter_project/models/vehicle.dart';
import 'package:flutter_project/customer/vehicle/vehicle_form.dart';
import 'package:provider/provider.dart';

class VehicleListView extends StatefulWidget {
  const VehicleListView({super.key});

  @override
  State<VehicleListView> createState() => _VehicleListViewState();
}

class _VehicleListViewState extends State<VehicleListView> {
  @override
  Widget build(BuildContext context) {
    List<Insurance> insuranceList =
        context.watch<InsuranceProvider>().insuranceList;
    List<Vehicle> vehicleList = context.watch<VehicleProvider>().vehicleList;

    for (var vehicle in vehicleList) {
      int index =
          insuranceList.indexWhere((ins) => ins.vehicleId == vehicle.id);
      if (index != -1) {
        vehicle.insurance =
            context.watch<InsuranceProvider>().insuranceList[index];
      }
    }

    if (context.read<VehicleProvider>().isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    // Show message if empty
    if (vehicleList.isEmpty) {
      return Center(
        child: Text(
          'No vehicles found',
          style: Theme.of(context).textTheme.titleSmall,
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemCount: vehicleList.length,
        itemBuilder: (context, i) {
          Vehicle vehicle = vehicleList[i];

          return Card(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8, left: 4, top: 4),
              child: ListTile(
                title: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  children: [
                    Text(vehicle.chassisNumber),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      color: Theme.of(context).highlightColor,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4, right: 4),
                        child: Text(
                          vehicle.regNumber,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
                trailing: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [actionDropDown(vehicle)],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${vehicle.carModel} (${vehicle.manuYear})'),
                    Text(
                        'Driver: ${vehicle.customerName} (${vehicle.driverAge()} years)'),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => showInsuranceStatusPage(vehicle),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: vehicle.insuranceStatus.color,
                          foregroundColor: Colors.black),
                      child: Text(
                        vehicle.insuranceStatus.label,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
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

  void showInsuranceStatusPage(Vehicle vehicle) {
    Status insuranseStatus = vehicle.insuranceStatus;

    Widget? page;
    String title = '';

    switch (insuranseStatus) {
      case Status.notInsured:
        page = NewInsurancePage(vehicle: vehicle);
        title = NewInsurancePage.title;
        break; // Not insured at all

      case Status.pendingApproval:
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar('Your insurance request is being processed',
              'Processing usually takes 2-3 business days', ContentType.help));
        return; // Sent insurance request, waiting for approval

      case Status.notPayed:
        page = RenewalPage(vehicle: vehicle);
        title = RenewalPage.title;
        break;

      case Status.payed:
        page = InsuredPage(vehicle: vehicle);
        title = InsuredPage.title;
    }

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PushedPageScaffold(page: page, title: title)));
  }

  Widget actionDropDown(Vehicle vehicle) {
    return MenuAnchor(
      menuChildren: [
        MenuItemButton(
          leadingIcon: Icon(Icons.edit),
          child: Text('Edit'),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Center(
                  child: SizedBox(
                    width: maxWidth,
                    child: Dialog(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 15,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Update Task',
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                IconButton(
                                  onPressed: () => Navigator.pop(context),
                                  icon: Icon(Icons.close),
                                ),
                              ],
                            ),
                            VehicleForm(
                              formType: FormType.update,
                              vehicle: vehicle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
        MenuItemButton(
          leadingIcon: Icon(Icons.delete),
          child: Text('Delete'),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Delete Task'),
                  content: Text(
                    'Are you sure you want to delete "${vehicle.carModel} (${vehicle.chassisNumber})"?',
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(snackBar(
                              'Delete Success',
                              'Vehicle deleted successfully',
                              ContentType.success));

                        context.read<VehicleProvider>().removeVehicle(vehicle);

                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.error,
                        foregroundColor: Theme.of(context).colorScheme.onError,
                      ),
                      child: Text('Delete'),
                    ),
                  ],
                  actionsAlignment: MainAxisAlignment.spaceBetween,
                );
              },
            );
          },
        ),
      ],
      builder: (context, controller, child) {
        return IconButton(
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: Icon(Icons.more_vert),
        );
      },
    );
  }
}
