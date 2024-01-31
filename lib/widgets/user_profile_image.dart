import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';

class UserProfileImage extends StatelessWidget {
  UserProfileImage(
      {super.key, required this.userModel, this.height, this.width});
  final UserModel? userModel;
  double? width;
  double? height;

  @override
  Widget build(BuildContext context) {
    return (userModel?.image?.isEmpty ?? true)
        ? Image.asset(
            'assets/images/profile_image_placeholder.png',
            height: height,
            width: width,
            fit: BoxFit.cover,
          )
        : CachedNetworkImage(
            imageUrl: userModel!.image!,
            fit: BoxFit.cover,
            width: width,
            height: height,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => Image.asset(
              'assets/images/profile_image_placeholder.png',
              width: width,
              height: height,
            ),
          );
  }
}
