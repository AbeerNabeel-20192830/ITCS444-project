import 'package:flutter/material.dart';
import 'package:flutter_project/insurance/insurance.dart';

class InsuranceRequestForm extends StatefulWidget {
  const InsuranceRequestForm({super.key});

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
  int selectedOfferIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (_selectedIndex) {
      case 0:
        page = _calculated();
        break;
      case 1:
        page = _offers();
        break;
      default:
        page = Placeholder();
    }

    return Form(
        child: Column(
      spacing: 8,
      children: [
        Text('Choose an insurance option',
            style: Theme.of(context).textTheme.bodyLarge),
        ToggleButtons(
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
          constraints: BoxConstraints(
              minWidth: (MediaQuery.of(context).size.width - 100) / 2,
              minHeight: 40),
          isSelected: _selectedTypes,
          children: _types,
        ),
        SizedBox(height: 8),
        page
      ],
    ));
  }

  Widget _calculated() {
    TextEditingController carPrice = TextEditingController();

    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: carPrice,
            decoration: const InputDecoration(
                labelText: 'Car Price When New',
                icon: Icon(Icons.attach_money),
                suffixText: 'BHD'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Car price is required';
              }

              if (double.tryParse(value) == null) {
                return 'Car price must be a number';
              }

              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _offers() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: InsuranceOffer.oferrsList.length,
        itemBuilder: (context, i) {
          InsuranceOffer offer = InsuranceOffer.oferrsList[i];

          return GestureDetector(
            
            onTap: () {
              setState(() {
                selectedOfferIndex = i;
              });
            },
            child: Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: selectedOfferIndex == i
                        ? Colors.blueAccent
                        : Colors.grey[200]!,
                    width: 1),
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
                  titleAlignment: ListTileTitleAlignment.top,
                  titleTextStyle: Theme.of(context).textTheme.titleSmall,
                  subtitleTextStyle: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
          );
        });
  }
}
