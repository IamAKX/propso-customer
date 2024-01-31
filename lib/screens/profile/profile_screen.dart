import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:propertycp_customer/main.dart';
import 'package:propertycp_customer/screens/adminlead/lead_users.dart';
import 'package:propertycp_customer/screens/onboarding/login_screen.dart';
import 'package:propertycp_customer/screens/profile/kyc/kyc.dart';
import 'package:propertycp_customer/screens/profile/post_property/post_property_screen.dart';
import 'package:propertycp_customer/screens/profile/users/user_list.dart';
import 'package:propertycp_customer/services/storage_service.dart';
import 'package:propertycp_customer/utils/colors.dart';
import 'package:propertycp_customer/widgets/gaps.dart';
import 'package:propertycp_customer/widgets/user_profile_image.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/user_model.dart';
import '../../services/api_service.dart';
import '../../services/snakbar_service.dart';
import '../../utils/enum.dart';
import '../../utils/preference_key.dart';
import '../../utils/theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.switchTabs});
  final Function(int index) switchTabs;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? userModel;
  late ApiProvider _api;
  late StorageProvider _storageProvider;
  bool isImageUploading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => loadScreen(),
    );
  }

  loadScreen() async {
    _api.getUserById(SharedpreferenceKey.getUserId()).then((value) {
      setState(() {
        userModel = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);
    _storageProvider = Provider.of<StorageProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    return Column(
      children: [
        header(context),
        const Divider(
          color: dividerColor,
          height: 10,
        ),
        Expanded(
          child: ListView(
            children: [
              // ListTile(
              //   leading: const Icon(
              //     LineAwesomeIcons.user_shield,
              //     color: textColorDark,
              //   ),
              //   title: Text(
              //     (userModel?.isKycVerified ?? false) ? 'KYC verified' : 'KYC',
              //     style: Theme.of(context).textTheme.titleMedium?.copyWith(
              //         color: (userModel?.isKycVerified ?? false)
              //             ? Colors.green
              //             : Colors.black),
              //   ),
              //   trailing: (userModel?.isKycVerified ?? false)
              //       ? null
              //       : const Icon(Icons.chevron_right),
              //   onTap: (userModel?.isKycVerified ?? false)
              //       ? null
              //       : () {
              //           Navigator.pushNamed(context, KycScreen.routePath)
              //               .then((value) => loadScreen());
              //         },
              // ),
              // const Divider(
              //   indent: defaultPadding * 3,
              //   color: dividerColor,
              // ),
              Visibility(
                visible: userModel?.userType == UserType.Admin.name,
                child: ListTile(
                  leading: const Icon(
                    LineAwesomeIcons.building,
                    color: textColorDark,
                  ),
                  title: Text(
                    'Post Property',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(),
                  ),
                  trailing: adminTrailingWidget(context),
                  onTap: () {
                    Navigator.pushNamed(context, PostProperty.routePath);
                  },
                ),
              ),
              Visibility(
                visible: userModel?.userType == UserType.Admin.name,
                child: const Divider(
                  indent: defaultPadding * 3,
                  color: dividerColor,
                ),
              ),
              Visibility(
                visible: userModel?.userType == UserType.Admin.name,
                child: ListTile(
                  leading: const Icon(
                    LineAwesomeIcons.user_plus,
                    color: textColorDark,
                  ),
                  title: Text(
                    'Users',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(),
                  ),
                  trailing: adminTrailingWidget(context),
                  onTap: () {
                    Navigator.pushNamed(context, UserListScreen.routePath)
                        .then((value) => loadScreen());
                  },
                ),
              ),
              Visibility(
                visible: userModel?.userType == UserType.Admin.name,
                child: const Divider(
                  indent: defaultPadding * 3,
                  color: dividerColor,
                ),
              ),
              Visibility(
                visible: userModel?.userType == UserType.Admin.name,
                child: ListTile(
                  leading: const Icon(
                    Icons.real_estate_agent_outlined,
                    color: textColorDark,
                  ),
                  title: Text(
                    'Leads',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(),
                  ),
                  trailing: adminTrailingWidget(context),
                  onTap: () {
                    Navigator.pushNamed(context, AllLeadUserScreen.routePath)
                        .then((value) => loadScreen());
                  },
                ),
              ),
              Visibility(
                visible: userModel?.userType == UserType.Admin.name,
                child: const Divider(
                  indent: defaultPadding * 3,
                  color: dividerColor,
                ),
              ),
              ListTile(
                leading: const Icon(
                  LineAwesomeIcons.comments_dollar,
                  color: textColorDark,
                ),
                title: Text(
                  'Refer and Earn',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  Share.share(
                      'User my referal code ${userModel?.referralCode ?? '-'} to earn bonus. Download PropertyCP from the App Store or Play Store now!');
                },
              ),
              const Divider(
                indent: defaultPadding * 3,
                color: dividerColor,
              ),
              ListTile(
                leading: const Icon(
                  LineAwesomeIcons.what_s_app,
                  color: textColorDark,
                ),
                title: Text(
                  'Reach on Whatsapp',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  const String phoneNumber = '+917019499017';
                  const String url = 'https://wa.me/$phoneNumber';

                  if (!await launchUrl(Uri.parse(url))) {
                    throw Exception('Could not launch $url');
                  }
                },
              ),
              const Divider(
                indent: defaultPadding * 3,
                color: dividerColor,
              ),
              ListTile(
                leading: const Icon(
                  LineAwesomeIcons.power_off,
                  color: Colors.red,
                ),
                title: Text(
                  'Logout',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.red),
                ),
                trailing: const Icon(Icons.chevron_right, color: Colors.red),
                onTap: () {
                  prefs.clear();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      LoginScreen.routePath, (route) => false);
                },
              ),
            ],
          ),
        )
      ],
    );
  }

  Row adminTrailingWidget(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Chip(
          padding: const EdgeInsets.all(0),
          label: Text(
            'Admin',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(),
          ),
        ),
        horizontalGap(defaultPadding / 2),
        const Icon(Icons.chevron_right),
      ],
    );
  }

  Padding header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Row(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(settingsPageUserIconSize),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: UserProfileImage(
                      userModel: userModel,
                      height: 100,
                      width: 100,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 1,
                  left: 75,
                  child: PopupMenuButton(
                    itemBuilder: (context) {
                      return const [
                        PopupMenuItem(
                          value: 'edit',
                          child: Text('Edit profile image'),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete profile image'),
                        ),
                      ];
                    },
                    enabled: !isImageUploading,
                    onSelected: (value) async {
                      switch (value) {
                        case 'edit':
                          final ImagePicker picker = ImagePicker();
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.gallery);
                          if (image != null) {
                            File imageFile = File(image.path);
                            setState(() {
                              isImageUploading = true;
                            });
                            _storageProvider
                                .uploadProfileImage(
                                    imageFile, userModel?.id ?? -1)
                                .then((value) async {
                              userModel?.image = value;
                              _api
                                  .updateUser(userModel?.toMap() ?? {},
                                      userModel?.id ?? -1)
                                  .then((value) {
                                isImageUploading = false;
                                loadScreen();
                              });
                            });
                          }
                          return;
                        case 'delete':
                          userModel?.image = '';
                          _api
                              .updateUser(
                                  userModel?.toMap() ?? {}, userModel?.id ?? -1)
                              .then((value) {
                            if (value) {
                              loadScreen();
                              SnackBarService.instance
                                  .showSnackBarSuccess('Profile image removed');
                            } else {
                              SnackBarService.instance
                                  .showSnackBarError('Failed to update');
                            }
                          });
                          return;
                      }
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: secondary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    horizontalGap(defaultPadding),
                    Expanded(
                      child: Text(
                        userModel?.fullName ?? '',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showEditNamePopup(context);
                      },
                      icon: const Icon(
                        Icons.edit,
                        size: 20,
                        color: secondary,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: defaultPadding),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.call_outlined,
                        size: 15,
                        color: primary,
                      ),
                      horizontalGap(defaultPadding / 2),
                      Text(
                        userModel?.mobileNo ?? '',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void showEditNamePopup(BuildContext context) {
    TextEditingController _editName =
        TextEditingController(text: userModel?.fullName ?? '');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Name'),
          content: TextField(
            controller: _editName,
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(
              hintText: 'Full Name',
              label: Text('Full Name'),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_editName.text.isEmpty) {
                  SnackBarService.instance
                      .showSnackBarError('Enter name to update');
                } else {
                  userModel?.fullName = _editName.text;
                  _api
                      .updateUser(userModel?.toMap() ?? {}, userModel?.id ?? -1)
                      .then((value) {
                    if (value) {
                      loadScreen();
                      SnackBarService.instance
                          .showSnackBarSuccess('Name updated');
                    } else {
                      SnackBarService.instance
                          .showSnackBarError('Failed to update');
                    }
                  });
                }
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
