import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gallery_image_viewer/gallery_image_viewer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_share/whatsapp_share.dart';

import '../utils/theme.dart';

class CustomImageViewer extends StatefulWidget {
  const CustomImageViewer({super.key, required this.link});
  static const String routePath = '/customImageViewer';
  final List<String> link;

  @override
  State<CustomImageViewer> createState() => _CustomImageViewerState();
}

class _CustomImageViewerState extends State<CustomImageViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery'),
        actions: [
          IconButton(
            onPressed: () async {
              String message =
                  "Hi, kindly tap on these links to view the property pictures.";
              for (var element in widget.link) {
                message = "$message$element\n\n";
              }

              Share.share(message, subject: 'Property Images');

              // await WhatsappShare.share(
              //   text:
              //       'Hi, kindly tap on these links to view the property pictures.',
              //   linkUrl: message,
              //   phone: ' ',
              // );
            },
            icon: Icon(Icons.share),
          ),
        ],
      ),
      body: getBody(),
    );
  }

  getBody() {
    log(widget.link.toString());
    return GridView.builder(
      padding: const EdgeInsets.all(defaultPadding / 2),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        crossAxisSpacing: defaultPadding / 2,
        mainAxisSpacing: defaultPadding / 2,
      ),
      itemCount: widget.link.length, // Number of items in the list
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            showImageViewer(
              context,
              Image.network(widget.link.elementAt(index)).image,
              swipeDismissible: true,
            );
          },
          child: CachedNetworkImage(
            imageUrl: widget.link.elementAt(index),
            fit: BoxFit.cover,
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => Container(
              alignment: Alignment.center,
              child: const Text(
                'Unable to load image',
              ),
            ),
          ),
        );
      },
    );
  }
}
