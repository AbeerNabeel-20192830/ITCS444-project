import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/admin/offers/offer_provider.dart';
import 'package:flutter_project/components/custom_snackbar.dart';
import 'package:flutter_project/models/insurance.dart';
import 'package:provider/provider.dart';

class OfferList extends StatefulWidget {
  const OfferList({super.key});

  @override
  State<OfferList> createState() => _OfferListState();
}

class _OfferListState extends State<OfferList> {
  @override
  Widget build(BuildContext context) {
    List offerList = context.watch<OfferProvider>().offerList;

    if (context.watch<OfferProvider>().isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (offerList.isEmpty) {
      return Center(child: Text('No offers yet'));
    }

    return ListView.builder(
        shrinkWrap: true,
        itemCount: offerList.length,
        itemBuilder: (context, i) {
          InsuranceOffer offer = offerList[i];

          return Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: Theme.of(context).colorScheme.primary, width: 2),
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
                trailing: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Card(
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
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          context.read<OfferProvider>().removeOffer(offer);

                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(snackBar(
                                'Delete Success',
                                'Offer deleted successfully',
                                ContentType.success));
                        },
                      ),
                    ]),
                titleAlignment: ListTileTitleAlignment.top,
                titleTextStyle: Theme.of(context).textTheme.titleSmall,
                subtitleTextStyle: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          );
        });
  }
}
