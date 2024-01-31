import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:propertycp_customer/models/property_media.dart';
import 'package:propertycp_customer/screens/edit_property.dart/edit_property_video.dart';
import 'package:propertycp_customer/utils/enum.dart';
import 'package:propertycp_customer/utils/theme.dart';
import 'package:propertycp_customer/widgets/gaps.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/options/completed.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../../models/property_model.dart';
import '../../models/user_model.dart';
import '../../services/api_service.dart';
import '../../services/snakbar_service.dart';
import '../../services/storage_service.dart';
import '../../utils/preference_key.dart';

class EditPropertyImage extends StatefulWidget {
  const EditPropertyImage({super.key, required this.propertyId});
  static const String routePath = '/editPropertyImage';
  final int propertyId;

  @override
  State<EditPropertyImage> createState() => _EditPropertyImageState();
}

class _EditPropertyImageState extends State<EditPropertyImage> {
  UserModel? userModel;
  late ApiProvider _api;
  PropertyModel? propertyModel;
  late StorageProvider _storageProvider;
  List<File> imageList = [];
  List<PropertyMedia> existingImage = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => loadScreen(),
    );
  }

  loadScreen() async {
    _api.getUserById(SharedpreferenceKey.getUserId()).then((value) async {
      userModel = value;
      propertyModel = await _api.getPropertyById(widget.propertyId);
      existingImage = propertyModel?.images
              ?.where((element) => element.mediaType == MediaType.Image.name)
              .toList() ??
          [];
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);
    _storageProvider = Provider.of<StorageProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Property Image'),
        actions: [
          TextButton(
            onPressed: () async {
              if (existingImage.length + imageList.length < 3) {
                SnackBarService.instance
                    .showSnackBarError('There should be atleast 3 images');
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
                    propertyModel?.mainImage = existingImage.first.url;
                    existingImage.addAll(propertyModel?.images
                            ?.where((element) =>
                                element.mediaType == MediaType.Video.name)
                            .toList() ??
                        []);
                    propertyModel?.images = existingImage;

                    _api
                        .updatePropety(propertyModel?.toMap() ?? {},
                            propertyModel?.id ?? -1)
                        .then((value) {
                      Navigator.pushNamed(context, EditPropertyVideo.routePath,
                          arguments: propertyModel?.id);
                    });
                  }
                },
              );

              for (var i = 0; i < imageList.length; i++) {
                String link = await _storageProvider.uploadPropertyImage(
                    imageList.elementAt(i), MediaType.Image.name);
                existingImage.add(
                    PropertyMedia(mediaType: MediaType.Image.name, url: link));
                pd.update(value: i + 1);
              }
            },
            child: _storageProvider.status == StorageStatus.loading ||
                    _api.status == ApiStatus.loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Text(
                    'Next',
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(color: Colors.white),
                  ),
          )
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
    return ListView(
      padding: const EdgeInsets.all(defaultPadding),
      children: [
        Text(
          'Existing image',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(defaultPadding / 2),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.0,
            crossAxisSpacing: defaultPadding / 2,
            mainAxisSpacing: defaultPadding / 2,
          ),
          itemCount: existingImage.length, // Number of items in the list
          itemBuilder: (context, index) {
            return Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: existingImage.elementAt(index).url ?? '',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
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
                IconButton(
                  onPressed: () {
                    setState(() {
                      existingImage.removeAt(index);
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
        ),
        verticalGap(defaultPadding),
        Text(
          'New image',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
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
        )
      ],
    );
  }
}
