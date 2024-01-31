import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:propertycp_customer/models/property_media.dart';
import 'package:propertycp_customer/models/property_model.dart';
import 'package:propertycp_customer/screens/profile/post_property/pick_propert_video.dart';
import 'package:propertycp_customer/services/snakbar_service.dart';
import 'package:propertycp_customer/utils/colors.dart';
import 'package:propertycp_customer/utils/enum.dart';
import 'package:propertycp_customer/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/options/completed.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../../../services/storage_service.dart';

class PickPropertyImages extends StatefulWidget {
  const PickPropertyImages({super.key, required this.model});
  static const String routePath = '/pickPropertyImages';
  final PropertyModel model;

  @override
  State<PickPropertyImages> createState() => _PickPropertyImagesState();
}

class _PickPropertyImagesState extends State<PickPropertyImages> {
  List<File> imageList = [];
  late StorageProvider _storageProvider;

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _storageProvider = Provider.of<StorageProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Property Image'),
        actions: [
          TextButton(
            onPressed: _storageProvider.status == StorageStatus.loading
                ? null
                : () async {
                    if (imageList.length < 3) {
                      SnackBarService.instance
                          .showSnackBarError('Add atleast 3 image');
                      return;
                    }

                    ProgressDialog pd = ProgressDialog(context: context);
                    pd.show(
                      max: imageList.length,
                      msg: 'Uploading images...',
                      progressType: ProgressType.valuable,
                      closeWithDelay: 2,
                      completed: Completed(completedMsg: 'Upload complete'),
                      onStatusChanged: (status) {
                        if (status == DialogStatus.closed) {
                          Navigator.pushReplacementNamed(
                              context, PickPropertyVideos.routePath,
                              arguments: widget.model);
                        }
                      },
                    );

                    for (var i = 0; i < imageList.length; i++) {
                      String link = await _storageProvider.uploadPropertyImage(
                          imageList.elementAt(i), MediaType.Image.name);
                      widget.model.images?.add(PropertyMedia(
                          mediaType: MediaType.Image.name, url: link));
                      pd.update(value: i + 1);
                    }
                    widget.model.mainImage = widget.model.images
                        ?.firstWhere((element) =>
                            element.mediaType == MediaType.Image.name)
                        .url;
                  },
            child: _storageProvider.status == StorageStatus.loading
                ? const SizedBox(
                    width: 80,
                    height: 80,
                    child: CircularProgressIndicator(),
                  )
                : Text(
                    'Next',
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
          final List<XFile> images = await picker.pickMultiImage();
          if (images != null && images.isNotEmpty) {
            setState(() {
              for (var element in images) {
                imageList.add(File(element.path));
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
    return imageList.isEmpty
        ? Center(
            child: Text(
              'Please tap on \'+\' button to select image',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: textColorDark),
            ),
          )
        : GridView.builder(
            padding: const EdgeInsets.all(defaultPadding / 2),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.0,
              crossAxisSpacing: defaultPadding / 2,
              mainAxisSpacing: defaultPadding / 2,
            ),
            itemCount: imageList.length, // Number of items in the list
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  Image.file(
                    imageList.elementAt(index),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        imageList.removeAt(index);
                      });
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  )
                ],
              );
            },
          );
  }
}
