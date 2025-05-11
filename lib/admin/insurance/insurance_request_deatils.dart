import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/components/custom_snackbar.dart';
import 'package:flutter_project/components/quotation_card.dart';
import 'package:flutter_project/components/vehicle_information_card.dart';
import 'package:flutter_project/models/insurance.dart';
import 'package:flutter_project/models/insurance_provider.dart';
import 'package:provider/provider.dart';

class InsuranceRequestDetails extends StatefulWidget {
  Insurance insurance;

  InsuranceRequestDetails({super.key, required this.insurance});

  @override
  State<InsuranceRequestDetails> createState() =>
      _InsuranceRequestDetailsState();
}

class _InsuranceRequestDetailsState extends State<InsuranceRequestDetails> {
  @override
  Widget build(BuildContext context) {
    Insurance insurance = widget.insurance;

    return Column(
      children: [
        vehicleInformationCard(context, insurance.vehicle!),
        Card.outlined(
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
                'Insurance Request Information',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              ListTile(
                leading: Text('Accident History?'),
                trailing: Text(insurance.accident ? 'Yes (+20 BHD)' : 'No'),
              ),
              ListTile(
                leading: Text('Driver younger than 24?'),
                trailing: Text(insurance.vehicle!.driverAge() < 24
                    ? 'Yes (+10 BHD)'
                    : 'No'),
              ),
            ],
          ),
        ),
        if (insurance.selectedOffer != null)
          Card.outlined(
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
                  'Selected Offer',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                ListTile(
                  leading: Text('Offer Name'),
                  trailing: Text(insurance.selectedOffer!.name),
                ),
                ListTile(
                  leading: Text('Offer Price'),
                  trailing: Text(insurance.selectedOffer!.price.toString()),
                ),
                ...insurance.selectedOffer!.features!.map(
                  (f) => ListTile(
                    trailing: Text("• $f"),
                  ),
                )
              ],
            ),
          ),
        SizedBox(
          height: 10,
        ),
        quotationCard(context, insurance),
        SizedBox(
          height: 10,
        ),
        ElevatedButton(
            onPressed: () {
              insurance.approve();
              context.read<InsuranceProvider>().updateInsurance(insurance);

              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(snackBar(
                    '${insurance.vehicle!.chassisNumber} Request Approved',
                    'A payment request was sent to the client',
                    ContentType.success));

              Navigator.pop(context);
            },
            child: Text('Approve'))
      ],
    );
  }
}
