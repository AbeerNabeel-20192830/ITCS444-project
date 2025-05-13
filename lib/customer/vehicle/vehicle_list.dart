import 'dart:developer';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/components/custom_snackbar.dart';
import 'package:flutter_project/components/pushed_page_scaffold.dart';
import 'package:flutter_project/customer/pages/accident_report_page.dart';
import 'package:flutter_project/customer/pages/insured_page.dart';
import 'package:flutter_project/customer/pages/new_insurance_page.dart';
import 'package:flutter_project/customer/pages/renewal_page.dart';
import 'package:flutter_project/models/insurance.dart';
import 'package:flutter_project/models/insurance_provider.dart';
import 'package:flutter_project/models/vehicle_provider.dart';
import 'package:flutter_project/models/vehicle.dart';
import 'package:flutter_project/customer/vehicle/vehicle_form.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

class VehicleListView extends StatefulWidget {
  const VehicleListView({super.key});

  @override
  State<VehicleListView> createState() => _VehicleListViewState();
}

class _VehicleListViewState extends State<VehicleListView> {
  String? searchKeyword;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final ScrollController scrollCtrl = ScrollController();

  List<Vehicle> filteredVehicles = [];

  List<Vehicle> filterVehicleList(List<Vehicle> vehicleList) {
    return vehicleList.where((vehicle) {
      searchKeyword = searchKeyword?.toLowerCase();
      if (searchKeyword == '') searchKeyword = null;

      final match = searchKeyword == null ||
          vehicle.chassisNumber.toLowerCase().contains(searchKeyword!) ||
          vehicle.regNumber.toLowerCase().contains(searchKeyword!) ||
          vehicle.carModel.toLowerCase().contains(searchKeyword!) ||
          vehicle.customerName.toLowerCase().contains(searchKeyword!) ||
          vehicle.insurance?.status.label
                  .toLowerCase()
                  .contains(searchKeyword!) ==
              true ||
          vehicle.manuYear.toString().contains(searchKeyword!);
      return match;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<InsuranceProvider>().insuranceList;

    if (context.read<VehicleProvider>().isLoading ||
        context.read<InsuranceProvider>().isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    filteredVehicles =
        filterVehicleList(context.watch<VehicleProvider>().vehicleList);

    inspect(context.watch<VehicleProvider>().vehicleList);

    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(
              labelText: 'Search', prefixIcon: Icon(Icons.search)),
          onChanged: (value) {
            searchKeyword = value;
            filteredVehicles =
                filterVehicleList(context.read<VehicleProvider>().vehicleList);
            setState(() {});
          },
        ),
        const SizedBox(height: 20),
        filteredVehicles.isEmpty
            ? const Center(child: Text("No matching records"))
            : AnimatedList(
                key: _listKey,
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                controller: scrollCtrl,
                initialItemCount: filteredVehicles.length,
                itemBuilder: (context, i, animation) {
                  if (i > filteredVehicles.length - 1) return SizedBox();

                  Vehicle vehicle = filteredVehicles[i];
                  return _buildAnimatedListItem(vehicle, i, animation);
                },
              ),
      ],
    );
  }

  Widget _buildAnimatedListItem(
      Vehicle vehicle, int index, Animation<double> animation) {
    return SlideTransition(
      position: animation.drive(
        Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).chain(
          CurveTween(curve: Curves.easeInOut),
        ),
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8, left: 4, top: 4),
          child: ListTile(
            title: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              children: [
                Text(vehicle.chassisNumber),
                Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  color: Theme.of(context).highlightColor,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4, right: 4),
                    child: Text(
                      vehicle.regNumber,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
            trailing: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                actionDropDown(vehicle, index, context, animation),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${vehicle.carModel} (${vehicle.manuYear})'),
                Text(
                    'Driver: ${vehicle.customerName} (${vehicle.driverAge()} years)'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => showInsuranceStatusPage(vehicle),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: vehicle.insuranceStatus.color,
                          foregroundColor: Colors.black),
                      child: Text(
                        vehicle.insuranceStatus.label,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextButton(
                      onPressed: () => showAccidentReportPage(vehicle),
                      child: const Text(
                        'Report Accident',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            titleAlignment: ListTileTitleAlignment.top,
            titleTextStyle: Theme.of(context).textTheme.titleSmall,
            subtitleTextStyle: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }

  void removeVehicleWithAnimation(int index) {
    final removedVehicle = filteredVehicles[index];
    filteredVehicles.removeAt(index);

    _listKey.currentState!.removeItem(
      index,
      (context, animation) =>
          _buildAnimatedListItem(removedVehicle, index, animation),
      duration: const Duration(milliseconds: 300),
    );

    context.read<VehicleProvider>().removeVehicle(removedVehicle);
  }

  showAccidentReportPage(Vehicle vehicle) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PushedPageScaffold(
                page: AccidentReportPage(vehicle: vehicle),
                title: 'Report Accident')));
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

  Widget actionDropDown(Vehicle vehicle, int index, BuildContext listContext,
      Animation<double> animation) {
    return MenuAnchor(
      menuChildren: [
        MenuItemButton(
          leadingIcon: const Icon(Icons.edit),
          child: const Text('Edit'),
          onPressed: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                opaque: false, // Makes the background transparent
                transitionDuration:
                    const Duration(milliseconds: 300), // Smooth duration
                reverseTransitionDuration: const Duration(milliseconds: 300),
                pageBuilder: (context, animation, secondaryAnimation) {
                  final curvedAnimation = CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeInOut, // Smooth easing curve
                  );

                  return Stack(
                    children: [
                      // Animated blurred background
                      AnimatedBlurBackground(animation: curvedAnimation),
                      // Animated dialog
                      AnimatedDialog(
                          animation: curvedAnimation, vehicle: vehicle),
                    ],
                  );
                },
              ),
            );
          },
        ),
        MenuItemButton(
          leadingIcon: const Icon(Icons.delete),
          child: const Text('Delete'),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Delete Vehicle'),
                  content: Text(
                    'Are you sure you want to delete "${vehicle.carModel} (${vehicle.chassisNumber})"?',
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(snackBar(
                              'Delete Success',
                              'Vehicle deleted successfully',
                              ContentType.success));

                        removeVehicleWithAnimation(index);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.error,
                        foregroundColor: Theme.of(context).colorScheme.onError,
                      ),
                      child: const Text('Delete'),
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
          icon: const Icon(Icons.more_vert),
        );
      },
    );
  }
}

class AnimatedBlurBackground extends StatelessWidget {
  final Animation<double> animation;

  const AnimatedBlurBackground({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    final blurValue =
        Tween<double>(begin: 0.0, end: 5.0).animate(animation).value;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: blurValue, sigmaY: blurValue),
      child: Container(
        color: Colors.black.withValues(alpha: 0.5), // Semi-transparent overlay
      ),
    );
  }
}

class AnimatedDialog extends StatelessWidget {
  final Animation<double> animation;
  final Vehicle vehicle;

  const AnimatedDialog(
      {super.key, required this.animation, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.8, end: 1.0).animate(animation),
        child: Center(
          child: SizedBox(
            width: 600, // Restore the dialog's original width
            child: SingleChildScrollView(
              child: Dialog(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Update Vehicle',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall, // Example
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close),
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
          ),
        ),
      ),
    );
  }
}
