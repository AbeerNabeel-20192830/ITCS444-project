import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/admin/offers/offer_provider.dart';
import 'package:flutter_project/components/custom_snackbar.dart';
import 'package:flutter_project/models/insurance.dart';
import 'package:provider/provider.dart';

class OfferForm extends StatefulWidget {
  const OfferForm({super.key});

  @override
  State<OfferForm> createState() => _OfferFormState();
}

class _OfferFormState extends State<OfferForm> {
  final GlobalKey<FormState> offerForm = GlobalKey<FormState>();
  List<String> features = [];
  TextEditingController offerName = TextEditingController();
  TextEditingController offerFeature = TextEditingController();
  TextEditingController offerPrice = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: offerForm,
      autovalidateMode: AutovalidateMode.onUnfocus,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Text(
            'New Offer',
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          TextFormField(
            controller: offerName,
            decoration: const InputDecoration(
              labelText: 'Offer Name',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Offer name must not be empty';
              }

              return null;
            },
          ),
          TextFormField(
            controller: offerPrice,
            decoration: const InputDecoration(
              labelText: 'Price',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Offer price must not be empty';
              }

              if (int.tryParse(value) == null) {
                return 'Offer price must be valid';
              }

              if (int.parse(value) <= 0) {
                return 'Offer price must be positive';
              }

              return null;
            },
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: offerFeature,
                  decoration: const InputDecoration(
                    labelText: 'Feature',
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  if (offerFeature.text.isNotEmpty) {
                    setState(() {
                      features.add(offerFeature.text);
                      offerFeature.clear();
                    });
                  }
                },
              ),
            ],
          ),

          const SizedBox(height: 10),
          // Display the list of features
          if (features.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Features:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ...features.map(
                  (f) => ListTile(
                    title: Text(f),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          features.remove(f);
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          Center(
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () => submitOffer(),
                    child: Text('Create Offer')),
                ElevatedButton(
                    onPressed: () => resetForm(), child: const Text('Reset'))
              ],
            ),
          ),
        ],
      ),
    );
  }

  submitOffer() {
    if (offerForm.currentState!.validate()) {
      offerForm.currentState!.save();

      InsuranceOffer offer = InsuranceOffer(
          name: offerName.text,
          price: double.parse(offerPrice.text),
          features: List.from(features));

      context.read<OfferProvider>().addOffer(offer);

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar(
            'Success', 'Offer added successfully', ContentType.success));

      resetForm();
    }
  }

  void resetForm() {
    offerForm.currentState!.reset();
    offerName.clear();
    offerPrice.clear();
    offerFeature.clear();
    features.clear();
    setState(() {});
  }
}
