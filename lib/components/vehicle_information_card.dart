import 'package:flutter/material.dart';
import 'package:flutter_project/models/vehicle.dart';

vehicleInformationCard(context, Vehicle vehicle) {
  return Card.outlined(
    child: ListView(
      shrinkWrap: true,
      padding: EdgeInsets.all(20),
      prototypeItem: ListTile(
        dense: true,
        visualDensity: VisualDensity(vertical: -4),
        leadingAndTrailingTextStyle: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(fontWeight: FontWeight.bold),
      ),
      children: [
        Text(
          'Vehicle Information',
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        ListTile(
          leading: Text('Customer Name'),
          trailing: Text(vehicle.customerName),
        ),
        ListTile(
          leading: Text('Chassis Number'),
          trailing: Text(vehicle.chassisNumber),
        ),
        ListTile(
          leading: Text('Registration Number'),
          trailing: Text(vehicle.regNumber),
        ),
        ListTile(
          leading: Text('Driver\'s Age'),
          trailing: Text('${vehicle.driverAge()} years'),
        ),
        ListTile(
          leading: Text('Manufacturing Year'),
          trailing: Text('${vehicle.manuYear}'),
        ),
        ListTile(
          leading: Text('Car Price When New'),
          trailing: Text('${vehicle.carPrice}'),
        ),
        ListTile(
          leading: Text('Car Price Now'),
          trailing: Text('${vehicle.carPriceNow()}'),
        ),
      ],
    ),
  );
}
