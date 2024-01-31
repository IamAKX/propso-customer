import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:propertycp_customer/utils/enum.dart';
import 'package:propertycp_customer/utils/theme.dart';
import 'package:propertycp_customer/widgets/user_profile_image.dart';
import 'package:provider/provider.dart';

import '../../../models/user_model.dart';
import '../../../services/api_service.dart';
import '../../../services/snakbar_service.dart';
import '../../../utils/colors.dart';
import '../../../widgets/gaps.dart';

class UserDetail extends StatefulWidget {
  const UserDetail({super.key, required this.userId});
  static const String routePath = '/userDetail';
  final int userId;

  @override
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  UserModel? userModel;
  late ApiProvider _api;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => loadScreen(),
    );
  }

  loadScreen() async {
    _api.getUserById(widget.userId).then((value) {
      setState(() {
        userModel = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
      ),
      body: _api.status == ApiStatus.loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : getBody(context),
    );
  }

  getBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(defaultPadding),
      children: [
        header(context),
        verticalGap(defaultPadding),
        Text(
          'UPI VPA',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(),
        ),
        Text(
          userModel?.vpa ?? '-',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        verticalGap(defaultPadding),
        Text(
          'Aadhaar',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(),
        ),
        Row(
          children: [
            Expanded(
              child: CachedNetworkImage(
                  imageUrl: userModel?.aadharFront?.trim() ?? '',
                  fit: BoxFit.fitWidth,
                  height: 130,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Center(
                        child: Text(
                          'Aadhaar front image not uploaded',
                          textAlign: TextAlign.center,
                        ),
                      )),
            ),
            horizontalGap(defaultPadding),
            Expanded(
              child: CachedNetworkImage(
                imageUrl: userModel?.aadharBack?.trim() ?? '',
                fit: BoxFit.fitWidth,
                height: 130,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Center(
                  child: Text(
                    'Aadhaar back image not uploaded',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          ],
        ),
        verticalGap(defaultPadding),
        Text(
          'PAN',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: CachedNetworkImage(
              imageUrl: userModel?.pan?.trim() ?? '',
              // fit: BoxFit.fitWidth,
              height: 130,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Center(
                    child: Text(
                      'PAN image not uploaded',
                      textAlign: TextAlign.center,
                    ),
                  )),
        ),
        verticalGap(defaultPadding * 2),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                ),
                onPressed: _api.status == ApiStatus.loading
                    ? null
                    : () {
                        userModel?.isKycVerified = false;
                        userModel?.status = UserStatus.SUSPENDED.name;
                        _api
                            .updateUser(
                                userModel?.toMap() ?? {}, userModel?.id ?? -1)
                            .then((value) {
                          if (value) {
                            SnackBarService.instance
                                .showSnackBarError('KYC rejected');
                            Navigator.pop(context);
                          }
                        });
                      },
                child: _api.status == ApiStatus.loading
                    ? CircularProgressIndicator()
                    : Text('Reject'),
              ),
            ),
            horizontalGap(defaultPadding),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                ),
                onPressed: _api.status == ApiStatus.loading
                    ? null
                    : () {
                        userModel?.isKycVerified = true;
                        userModel?.status = UserStatus.ACTIVE.name;
                        _api
                            .updateUser(
                                userModel?.toMap() ?? {}, userModel?.id ?? -1)
                            .then((value) {
                          if (value) {
                            SnackBarService.instance
                                .showSnackBarSuccess('KYC approved');
                            Navigator.pop(context);
                          }
                        });
                      },
                child: _api.status == ApiStatus.loading
                    ? CircularProgressIndicator()
                    : Text('Approve'),
              ),
            )
          ],
        ),
      ],
    );
  }

  header(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              ClipOval(
                child: UserProfileImage(
                  userModel: userModel,
                  width: 80,
                  height: 80,
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
    );
  }
}
