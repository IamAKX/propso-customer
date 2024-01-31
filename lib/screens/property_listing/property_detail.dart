import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:propertycp_customer/models/property_media.dart';
import 'package:propertycp_customer/screens/enquiry/enquiry_screen.dart';
import 'package:propertycp_customer/utils/colors.dart';
import 'package:propertycp_customer/utils/constants.dart';
import 'package:propertycp_customer/utils/enum.dart';
import 'package:propertycp_customer/utils/theme.dart';
import 'package:propertycp_customer/widgets/custom_image_viewer.dart';
import 'package:propertycp_customer/widgets/custom_video_player.dart';
import 'package:propertycp_customer/widgets/gaps.dart';
import 'package:propertycp_customer/widgets/video_gallery.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import '../../models/property_model.dart';
import '../../models/user_model.dart';
import '../../services/api_service.dart';
import '../../services/snakbar_service.dart';
import '../../utils/preference_key.dart';
import '../leads/create_lead.dart';

class PropertyDetailScreen extends StatefulWidget {
  const PropertyDetailScreen({super.key, required this.propertyId});
  final int propertyId;
  static const String routePath = '/propertyDeatilScreen';
  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  UserModel? userModel;
  late ApiProvider _api;
  PropertyModel? property;

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
      property = await _api.getPropertyById(widget.propertyId);

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        actions: [
          // Visibility(
          //   visible: userModel?.userType == UserType.Admin.name,
          //   child: IconButton(
          //       onPressed: () {
          //         _api.deletePropety(property?.id ?? -1).then((value) {
          //           SnackBarService.instance
          //               .showSnackBarSuccess('Property deleted');
          //           Navigator.pop(context);
          //         });
          //       },
          //       icon: Icon(Icons.delete)),
          // ),
          // Visibility(
          //   visible: userModel?.userType == UserType.Admin.name,
          //   child: IconButton(
          //       onPressed: () {
          //         Navigator.pushNamed(context, EditPropertyText.routePath,
          //                 arguments: property?.id)
          //             .then((value) {
          //           loadScreen();
          //         });
          //       },
          //       icon: Icon(Icons.edit)),
          // ),
          IconButton(
            onPressed: () {
              if (prefs
                      .getStringList(SharedpreferenceKey.favourite)
                      ?.contains(property?.id?.toString()) ??
                  false) {
                SharedpreferenceKey.removeFromFavourite(
                    property?.id?.toString() ?? '');
              } else {
                SharedpreferenceKey.addToFavourite(
                    property?.id?.toString() ?? '');
              }
              setState(() {});
            },
            icon: (prefs
                        .getStringList(SharedpreferenceKey.favourite)
                        ?.contains(property?.id?.toString()) ??
                    false)
                ? const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  )
                : const Icon(
                    Icons.favorite_border_outlined,
                  ),
          ),
        ],
      ),
      body: _api.status == ApiStatus.loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : getBody(context),
      floatingActionButton: FloatingActionButton(
        backgroundColor: secondary,
        onPressed: () {
          Navigator.pushNamed(context, EnquiryScreen.routePath,
              arguments: widget.propertyId);
        },
        child: const Icon(
          Icons.question_mark_rounded,
          color: Colors.white,
          size: 35,
        ),
      ),
    );
  }

  getBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        header(context),
        Expanded(
          child: ListView(
            children: [
              Card(
                elevation: 5,
                margin: const EdgeInsets.all(defaultPadding),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(defaultPadding / 2),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: secondary, //primary,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5),
                        ),
                      ),
                      child: Text(
                        'Property Information',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    verticalGap(defaultPadding / 2),
                    rowWithTwoItem(context, 'Type', '${property?.type}', 'Area',
                        '${property?.area} ${property?.areaUnit}'),
                    verticalGap(defaultPadding / 2),
                    rowWithTwoItem(
                        context,
                        'Price',
                        '$rupee ${property?.price}',
                        'City',
                        '${property?.city}'),
                    verticalGap(defaultPadding / 2),
                  ],
                ),
              ),
              Card(
                elevation: 5,
                margin: const EdgeInsets.fromLTRB(
                  defaultPadding,
                  0,
                  defaultPadding,
                  defaultPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(defaultPadding / 2),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: secondary, // primary,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5),
                        ),
                      ),
                      child: Text(
                        'Description',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: Text('${property?.description}'),
                    )
                  ],
                ),
              ),
              Visibility(
                visible: userModel?.userType == UserType.Admin.name &&
                    (property?.builderPhoneNumber?.isNotEmpty ?? false),
                child: Card(
                  elevation: 5,
                  margin: const EdgeInsets.fromLTRB(
                    defaultPadding,
                    0,
                    defaultPadding,
                    defaultPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(defaultPadding / 2),
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: secondary, // primary,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                          ),
                        ),
                        child: Text(
                          'Builder Phone',
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () async {
                              launch("tel://${property?.builderPhoneNumber}");
                            },
                            icon: const Icon(
                              Icons.call,
                              color: Colors.green,
                            ),
                          ),
                          Text('${property?.builderPhoneNumber}'),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Padding rowWithTwoItem(BuildContext context, String key1, String value1,
      String key2, String value2) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: Row(
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                text: '$key1\n',
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: hintColor),
                children: <TextSpan>[
                  TextSpan(
                    text: value1,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: textColorDark,
                        fontWeight: FontWeight.bold,
                        height: 1.5),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: '$key2\n',
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: hintColor),
                children: <TextSpan>[
                  TextSpan(
                    text: value2,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: textColorDark,
                        fontWeight: FontWeight.bold,
                        height: 1.5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  SizedBox header(BuildContext context) {
    if (property?.images?.isEmpty ?? true) {
      return SizedBox();
    }
    return SizedBox(
      height: 250,
      width: double.infinity,
      child: Stack(
        children: [
          Container(
            height: 250,
            width: double.infinity,
            child: CarouselSlider(
              items: property?.images?.map((e) {
                if (e.mediaType == MediaType.Image.name) {
                  return buildImageBanner(e);
                } else {
                  return buildVideoBanner(e);
                }
              }).toList(),
              options: CarouselOptions(viewportFraction: 1, height: 250),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, CustomImageViewer.routePath,
                        arguments: property?.images
                            ?.where((e) => e.mediaType == MediaType.Image.name)
                            .map((e) => e.url!)
                            .toList());
                  },
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        const Icon(LineAwesomeIcons.image,
                            size: 15, color: Colors.white),
                        horizontalGap(8),
                        Text(
                          '${property?.images?.where((element) => element.mediaType == MediaType.Image.name).length} Photos',
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, VideoGallery.routePath,
                        arguments: property?.images
                            ?.where((e) => e.mediaType == MediaType.Video.name)
                            .toList());
                  },
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        const Icon(LineAwesomeIcons.video_file,
                            size: 15, color: Colors.white),
                        horizontalGap(8),
                        Text(
                          '${property?.images?.where((element) => element.mediaType == MediaType.Video.name).length} Videos',
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildImageBanner(PropertyMedia e) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, CustomImageViewer.routePath,
            arguments: property?.images
                ?.where((e) => e.mediaType == MediaType.Image.name)
                .map((e) => e.url!)
                .toList());
      },
      child: CachedNetworkImage(
        imageUrl: e.url ?? '',
        fit: BoxFit.fitWidth,
        width: double.infinity,
        height: 250,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 250,
          child: const Text(
            'Unable to load image',
          ),
        ),
      ),
    );
  }

  Widget buildVideoBanner(PropertyMedia e) {
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: e.thumbnail ?? '',
          fit: BoxFit.fitWidth,
          width: double.infinity,
          height: 250,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 250,
            child: const Text(
              'Unable to load image',
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, CustomVideoPlayer.routePath,
                  arguments: e.url);
            },
            child: const Icon(
              Icons.play_arrow_rounded,
              size: 50,
              color: primary,
            ),
          ),
        ),
      ],
    );
  }
}
