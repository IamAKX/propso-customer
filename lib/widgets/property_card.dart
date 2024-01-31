import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:propertycp_customer/models/property_model.dart';
import 'package:propertycp_customer/screens/property_listing/property_detail.dart';

import '../main.dart';
import '../utils/colors.dart';
import '../utils/preference_key.dart';
import '../utils/theme.dart';
import 'gaps.dart';

class PropertyCard extends StatefulWidget {
  PropertyCard({Key? key, required this.property, this.reload})
      : super(key: key);
  final PropertyModel? property;
  Function? reload;

  @override
  State<PropertyCard> createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(defaultPadding / 2),
      child: SizedBox(
        width: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 150,
              width: double.infinity,
              child: Stack(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                              context, PropertyDetailScreen.routePath,
                              arguments: widget.property?.id)
                          .then((value) {
                        if (widget.reload != null) {
                          widget.reload!();
                        }
                        if (this.mounted) {
                          setState(() {});
                        }
                      });
                    },
                    child: CachedNetworkImage(
                      imageUrl: widget.property?.mainImage ?? '',
                      fit: BoxFit.fitWidth,
                      width: double.infinity,
                      height: 150,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: 150,
                        child: const Text(
                          'Unable to load image',
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () {
                        if (prefs
                                .getStringList(SharedpreferenceKey.favourite)
                                ?.contains(widget.property?.id?.toString()) ??
                            false) {
                          SharedpreferenceKey.removeFromFavourite(
                              widget.property?.id?.toString() ?? '');
                        } else {
                          SharedpreferenceKey.addToFavourite(
                              widget.property?.id?.toString() ?? '');
                        }
                        if (widget.reload != null) {
                          widget.reload!();
                        }
                        setState(() {});
                      },
                      icon: (prefs
                                  .getStringList(SharedpreferenceKey.favourite)
                                  ?.contains(widget.property?.id?.toString()) ??
                              false)
                          ? const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : const Icon(
                              Icons.favorite_border_outlined,
                            ),
                    ),
                  )
                ],
              ),
            ),
            verticalGap(5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                widget.property?.title ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: textColorDark,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Text(
                widget.property?.subTitle ?? '',
                style: Theme.of(context).textTheme.titleSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${widget.property?.price ?? ''}'),
                  Text(widget.property?.bhk ?? ''),
                ],
              ),
            ),
            verticalGap(defaultPadding / 2),
          ],
        ),
      ),
    );
  }
}
