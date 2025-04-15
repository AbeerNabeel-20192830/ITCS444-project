import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/components/custom_snackbar.dart';
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
        shrinkWrap: true,
        itemCount: vehicleList.length,
        itemBuilder: (context, i) {
          Vehicle vehicle = vehicleList[i];

          return ListTile(
            title: Text(vehicle.carModel),
            trailing: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [actionDropDown(vehicle)],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(vehicle.chassisNumber),
                SizedBox(height: 20),
              ],
            ),
            titleAlignment: ListTileTitleAlignment.top,
            titleTextStyle: Theme.of(context).textTheme.titleSmall,
            subtitleTextStyle: Theme.of(context).textTheme.bodyLarge,
          );
        });
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
