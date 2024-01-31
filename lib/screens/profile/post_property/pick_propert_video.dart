import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:propertycp_customer/screens/profile/post_property/post_property_screen.dart';
import 'package:propertycp_customer/utils/colors.dart';
import 'package:propertycp_customer/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/options/completed.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../models/property_media.dart';
import '../../../models/property_model.dart';
import '../../../services/api_service.dart';
import '../../../services/snakbar_service.dart';
import '../../../services/storage_service.dart';
import '../../../utils/enum.dart';

class PickPropertyVideos extends StatefulWidget {
  const PickPropertyVideos({super.key, required this.model});
  static const String routePath = '/pickPropertyVideos';
  final PropertyModel model;

  @override
  State<PickPropertyVideos> createState() => _PickPropertyVideosState();
}

class _PickPropertyVideosState extends State<PickPropertyVideos> {
  List<File> videoList = [];
  late ApiProvider _api;
  late StorageProvider _storageProvider;
  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);
    _storageProvider = Provider.of<StorageProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Property Videos'),
        actions: [
          TextButton(
            onPressed: _storageProvider.status == StorageStatus.loading ||
                    _api.status == ApiStatus.loading
                ? null
                : () async {
                    if (videoList.isEmpty) {
                      SnackBarService.instance
                          .showSnackBarError('Add atleast 1 video');
                      return;
                    }
                    ProgressDialog pd = ProgressDialog(context: context);
                    pd.show(
                      max: videoList.length,
                      msg: 'Uploading videos...',
                      progressType: ProgressType.valuable,
                      closeWithDelay: 2,
                      completed: Completed(completedMsg: 'Upload complete'),
                      onStatusChanged: (status) {
                        if (status == DialogStatus.closed) {
                          _api.createProperty(widget.model).then((value) {
                            if (value) {
                              SnackBarService.instance
                                  .showSnackBarSuccess('Property posted');
                              Navigator.pushReplacementNamed(
                                  context, PostProperty.routePath);
                            } else {
                              SnackBarService.instance
                                  .showSnackBarError('Failed to post property');
                            }
                          });
                        }
                      },
                    );
                    for (var i = 0; i < videoList.length; i++) {
                      String link = await _storageProvider.uploadPropertyImage(
                          videoList.elementAt(i), MediaType.Video.name);
                      String? thumbNail = '';
                      thumbNail = await VideoThumbnail.thumbnailFile(
                        video: link,
                        imageFormat: ImageFormat.JPEG,
                        maxHeight:
                            250, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
                        quality: 99,
                      );
                      log(thumbNail!);
                      File tmb = File(thumbNail!);
                      thumbNail =
                          await _storageProvider.uploadPropertyThumbnail(tmb);
                      widget.model.images?.add(
                        PropertyMedia(
                          mediaType: MediaType.Video.name,
                          url: link,
                          thumbnail: thumbNail,
                        ),
                      );
                      pd.update(value: i + 1);
                    }
                  },
            child: _storageProvider.status == StorageStatus.loading ||
                    _api.status == ApiStatus.loading
                ? const SizedBox(
                    width: 80,
                    height: 80,
                    child: CircularProgressIndicator(),
                  )
                : Text(
                    'Done',
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(color: Colors.white),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final ImagePicker picker = ImagePicker();
          final List<XFile> videos = await picker.pickMultipleMedia();
          if (videos != null && videos.isNotEmpty) {
            setState(() {
              for (var element in videos) {
                videoList.add(File(element.path));
              }
            });
          }
        },
        child: const Icon(Icons.add),
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    return videoList.isEmpty
        ? Center(
            child: Text(
              'Please tap on \'+\' button to select video',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: textColorDark),
            ),
          )
        : GridView.builder(
            padding: const EdgeInsets.all(defaultPadding / 2),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 16 / 9,
              crossAxisSpacing: defaultPadding / 2,
              mainAxisSpacing: defaultPadding / 2,
            ),
            itemCount: videoList.length,
            itemBuilder: (context, index) {
              return FutureBuilder<Uint8List?>(
                future: generateThumbnail(videoList.elementAt(index).path),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    return Stack(
                      children: [
                        Image.memory(
                          snapshot.data!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              videoList.removeAt(index);
                            });
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        )
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              );
            },
          );
  }

  Future<Uint8List?> generateThumbnail(String videoPath) async {
    final thumbnail = await VideoThumbnail.thumbnailData(
      video: videoPath,
      imageFormat: ImageFormat.JPEG,
      quality: 100,
    );

    return thumbnail;
  }
}
