import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:whatsapp_share/whatsapp_share.dart';

import '../models/property_media.dart';
import '../utils/theme.dart';
import 'custom_video_player.dart';

class VideoGallery extends StatefulWidget {
  const VideoGallery({super.key, required this.link});
  static const String routePath = '/videoGallery';
  final List<PropertyMedia> link;

  @override
  State<VideoGallery> createState() => _VideoGalleryState();
}

class _VideoGalleryState extends State<VideoGallery> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery'),
        actions: [
          IconButton(
            onPressed: () async {
              String message =
                  "Hi, kindly tap on these links to view the property videos.";
              for (PropertyMedia element in widget.link) {
                message = "$message${element.url}\n\n";
              }

              Share.share(message, subject: 'Property Videos');
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
    return GridView.builder(
      padding: const EdgeInsets.all(defaultPadding / 2),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 16 / 9,
        crossAxisSpacing: defaultPadding / 2,
        mainAxisSpacing: defaultPadding / 2,
      ),
      itemCount: widget.link.length, // Number of items in the list
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.pushNamed(context, CustomVideoPlayer.routePath,
                arguments: widget.link.elementAt(index).url);
          },
          child: Stack(
            children: [
              CachedNetworkImage(
                imageUrl: widget.link.elementAt(index).thumbnail ?? '',
                fit: BoxFit.fitWidth,
                width: double.infinity,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'Unable to load thumbnail',
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.play_arrow_rounded,
                  size: 50,
                  color: Colors.white,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
