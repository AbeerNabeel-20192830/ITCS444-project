import 'package:flutter/material.dart';
import 'package:flutter_project/models/insurance.dart';
import 'package:flutter_project/utils.dart';

Card quotationCard(context, Insurance insurance) {
  return Card.filled(
    color: Theme.of(context).colorScheme.primaryContainer,
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
          'Insurance Quotation',
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        ListTile(
          leading: Text('Insurance Date'),
          trailing: Text(dateToString(insurance.startDate = DateTime.now())),
        ),
        ListTile(
          leading: Text('Expiration Date'),
          trailing: Text(dateToString(insurance.endDate = DateTime(
              insurance.startDate!.year + 1,
              insurance.startDate!.month,
              insurance.startDate!.day))),
        ),
        ListTile(
          leading: Text('Total Amount'),
          trailing: Text("${insurance.price()} BHD"),
        ),
      ],
    ),
  );
}
