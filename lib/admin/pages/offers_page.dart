import 'package:flutter/material.dart';
import 'package:flutter_project/admin/offers/offer_list.dart';
import 'package:flutter_project/admin/offers/offer_form.dart';

class OffersPage extends StatefulWidget {
  const OffersPage({super.key});

  @override
  State<OffersPage> createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
        ),
        OfferForm(),
        SizedBox(
          height: 20,
        ),
        Text(
          'My Offers',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SizedBox(
          height: 20,
        ),
        OfferList()
      ],
    );
  }
}
