import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/admin/offers/offer_provider.dart';
import 'package:flutter_project/components/custom_snackbar.dart';
import 'package:flutter_project/models/insurance.dart';
import 'package:flutter_project/models/insurance_provider.dart';
import 'package:flutter_project/models/vehicle.dart';
import 'package:provider/provider.dart';

class InsuranceRequestForm extends StatefulWidget {
  Vehicle vehicle;
  InsuranceRequestForm({super.key, required this.vehicle});

  @override
  State<InsuranceRequestForm> createState() => _InsuranceRequestFormState();
}

class _InsuranceRequestFormState extends State<InsuranceRequestForm> {
  final List<Widget> _types = [
    Text('Calculated'),
    Text('Insurance Offers'),
  ];
  final List<bool> _selectedTypes = [true, false];
  int _selectedIndex = 0;
  int selectedOfferIndex = -1;
  bool accident = false;

  @override
  Widget build(BuildContext context) {
    Vehicle vehicle = widget.vehicle;

    Widget page;
    switch (_selectedIndex) {
      case 0:
        page = _calculated();
        selectedOfferIndex = -1;
        break;
      case 1:
        page = _offers();
        break;
      default:
        page = Placeholder();
    }

    return Column(
      spacing: 8,
      children: [
        Text('Choose an insurance option',
            style: Theme.of(context).textTheme.bodyLarge),
        LayoutBuilder(builder: (context, constraints) {
          return ToggleButtons(
            onPressed: (index) {
              setState(() {
                if (_selectedIndex > -1) {
                  _selectedTypes[_selectedIndex] = false;
                  _selectedIndex = index;
                  _selectedTypes[_selectedIndex] = true;
                }
              });
            },
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            // selectedBorderColor: Theme.of(context).primaryColor,
            selectedColor: Theme.of(context).colorScheme.onPrimary,
            fillColor: Theme.of(context).colorScheme.primary,
            color: Theme.of(context).colorScheme.primary,
            constraints: BoxConstraints.expand(
                width: (constraints.maxWidth / 2) - 3, height: 40),
            isSelected: _selectedTypes,
            children: _types,
          );
        }),
        SizedBox(height: 8),
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
                'Vehicle Information *',
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
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              '* You can update vehicle information in "My Vehicles" page.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ),
        SizedBox(height: 8),
        page
      ],
    );
  }

  Widget _calculated() {
    Vehicle vehicle = widget.vehicle;

    return Form(
      child: Column(
        spacing: 20,
        children: [
          Card.filled(
            child: CheckboxListTile(
                title: Text('Does the vehicle have an accident history?'),
                value: accident,
                onChanged: (value) => setState(() {
                      accident = value!;
                    })),
          ),
          ListTile(
            tileColor: Theme.of(context).colorScheme.primaryContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            leading: Text(
              'Estimated Price: ',
            ),
            trailing: Text(
              '${Insurance.estimatePrice(vehicle, accident)} BHD',
            ),
            leadingAndTrailingTextStyle: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
          ),
          ElevatedButton(
              onPressed: () => submitInsuranceRequest(),
              child: Text('Submit Request'))
        ],
      ),
    );
  }

  void submitInsuranceRequest() async {
    List offerList = context.read<OfferProvider>().offerList;
    Vehicle vehicle = widget.vehicle;
    Insurance insurance;

    if (selectedOfferIndex != -1) {
      InsuranceOffer offer = offerList[selectedOfferIndex];
      insurance = Insurance(
        vehicleId: vehicle.id,
        vehicle: vehicle,
        selectedOffer: offer,
      );
    } else {
      insurance = Insurance(
        vehicleId: vehicle.id,
        vehicle: vehicle,
        accident: accident,
      );
    }

    vehicle.insurance = insurance;

    context.read<InsuranceProvider>().addInsurance(insurance);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar('Your insurance request was sent',
          'Processing usually takes 2-3 business days', ContentType.success));

    Navigator.pop(context);
  }

  Widget _offers() {
    List offerList = context.watch<OfferProvider>().offerList;

    return Column(
      spacing: 20,
      children: [
        ListView.builder(
            shrinkWrap: true,
            itemCount: offerList.length,
            itemBuilder: (context, i) {
              InsuranceOffer offer = offerList[i];

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (selectedOfferIndex != i) {
                      selectedOfferIndex = i;
                    } else {
                      selectedOfferIndex = -1;
                    }
                  });
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: selectedOfferIndex == i
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent,
                        width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8, left: 4, top: 4),
                    child: ListTile(
                      title: Text(offer.name),
                      subtitle: ListView.builder(
                        shrinkWrap: true,
                        itemCount: offer.features!.length,
                        itemBuilder: (context, i) {
                          String feature = offer.features![i];
                          return Text('•  $feature');
                        },
                      ),
                      trailing: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                        color: Theme.of(context).colorScheme.primaryFixedDim,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4, right: 4),
                          child: Text(
                            '${offer.price} BHD',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryFixed),
                          ),
                        ),
                      ),
                      titleAlignment: ListTileTitleAlignment.top,
                      titleTextStyle: Theme.of(context).textTheme.titleSmall,
                      subtitleTextStyle: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
              );
            }),
        ElevatedButton(
            onPressed: () => submitInsuranceRequest(),
            child: Text('Choose Offer'))
      ],
    );
  }
}
