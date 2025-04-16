import 'package:age_calculator/age_calculator.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/components/custom_snackbar.dart';
import 'package:flutter_project/components/pushed_page_scaffold.dart';
import 'package:flutter_project/customer/pages/insured_page.dart';
import 'package:flutter_project/customer/pages/new_insurance_page.dart';
import 'package:flutter_project/customer/pages/renewal_page.dart';
import 'package:flutter_project/utils.dart';
import 'package:flutter_project/vehicle/vehicle.dart';
import 'package:flutter_project/vehicle/vehicle_form.dart';

class VehicleListView extends StatefulWidget {
  final Function() notifyParent;

  const VehicleListView({super.key, required this.notifyParent});

  @override
  State<VehicleListView> createState() => _VehicleListViewState();
}

class _VehicleListViewState extends State<VehicleListView> {
  @override
  Widget build(BuildContext context) {
    List<Vehicle> vehicleList = Vehicle.vehicleList;

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
                    Text('${vehicle.carModel} (${vehicle.manuYear.year})'),
                    Text(
                        'Driver: ${vehicle.customerName} (${AgeCalculator.age(vehicle.driverBirth).years} years)'),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => showInsuranceStatusPage(vehicle),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: vehicle.insured
                            ? Colors.green[600]
                            : Theme.of(context).colorScheme.error,
                        foregroundColor: vehicle.insured
                            ? Colors.green[100]
                            : Theme.of(context).colorScheme.onError,
                      ),
                      child: Text(vehicle.insured ? 'Insured' : 'Not insured'),
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
    bool insured = vehicle.insured;
    bool renewal = vehicle.renewal;

    // 3 actual cases:
    // insured (renewal or not): VIEW DETAILS
    // not insured and renewal: RENEWAL
    // not insured and not renewal: NEW REQUEST

    Widget page;
    String title = '';

    if (insured) {
      page = InsuredPage(vehicle: vehicle);
      title = InsuredPage.title;
    } else if (!insured && renewal) {
      page = RenewalPage(vehicle: vehicle);
      title = RenewalPage.title;
    } else {
      page = NewInsurancePage(vehicle: vehicle);
      title = NewInsurancePage.title;
    }

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PushedPageScaffold(page: page, title: title)));
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
                              notifyParent: widget.notifyParent,
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

                        setState(() {
                          Vehicle.vehicleList.remove(vehicle);
                        });
                        vehicle.removeFromLocal();

                        Navigator.pop(context);
                        widget.notifyParent();
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
