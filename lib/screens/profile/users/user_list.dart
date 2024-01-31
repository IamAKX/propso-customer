import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:propertycp_customer/models/list/user_list.dart';
import 'package:propertycp_customer/screens/profile/users/user_detail.dart';
import 'package:propertycp_customer/utils/colors.dart';
import 'package:propertycp_customer/utils/date_time_formatter.dart';
import 'package:propertycp_customer/utils/enum.dart';
import 'package:propertycp_customer/utils/helper_method.dart';
import 'package:propertycp_customer/widgets/user_profile_image.dart';
import 'package:provider/provider.dart';

import '../../../models/user_model.dart';
import '../../../services/api_service.dart';
import '../../../services/snakbar_service.dart';
import '../../../utils/dummy.dart';
import '../../../utils/preference_key.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});
  static const String routePath = '/userListScreen';

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  UserModel? userModel;
  late ApiProvider _api;
  UserListModel? userList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => loadScreen(),
    );
  }

  loadScreen() async {
    userList = await _api.getAllUsers();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          TextButton(
            onPressed: () {
              showCreateUserPopup(context);
            },
            child: Text(
              'Create',
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    if (_api.status == ApiStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return ListView.builder(
      itemCount: userList?.data?.length ?? 0,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Stack(
            children: [
              ClipOval(
                child: UserProfileImage(
                  userModel: userList?.data?.elementAt(index),
                  width: 50,
                  height: 50,
                ),
              ),
              Positioned(
                right: 0,
                bottom: 1,
                child: Icon(
                  Icons.circle,
                  size: 15,
                  color:
                      (userList?.data?.elementAt(index).isKycVerified ?? false)
                          ? Colors.green
                          : Colors.red,
                ),
              ),
            ],
          ),
          title: Text(
            userList?.data?.elementAt(index).fullName ?? '',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          trailing: const Icon(Icons.chevron_right),
          subtitle: Row(
            children: [
              // (userList?.data?.elementAt(index).isKycVerified ?? true)
              //     ? Text(
              //         'KYC not verified',
              //         style: Theme.of(context)
              //             .textTheme
              //             .titleSmall
              //             ?.copyWith(color: Colors.red),
              //       )
              //     : Text(
              //         'KYC verified',
              //         style: Theme.of(context)
              //             .textTheme
              //             .titleSmall
              //             ?.copyWith(color: Colors.green),
              //       ),

              Text(
                userList?.data?.elementAt(index).status ?? '',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: getColorByStatus(
                        userList?.data?.elementAt(index).status ?? '')),
              ),
              const Spacer(),
            ],
          ),
          onTap: () => Navigator.of(context)
              .pushNamed(UserDetail.routePath,
                  arguments: userList?.data?.elementAt(index).id ?? -1)
              .then((value) => loadScreen()),
        );
      },
    );
  }

  void showCreateUserPopup(BuildContext context) {
    TextEditingController _editPhone = TextEditingController();
    TextEditingController _editName = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create user'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _editName,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  hintText: 'Full Name',
                  label: Text('Full Name'),
                ),
              ),
              TextField(
                controller: _editPhone,
                maxLength: 10,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: 'Phone number',
                  label: Text('Phone number'),
                ),
              ),
            ],
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
                UserModel model = UserModel(
                  fullName: _editName.text,
                  mobileNo: _editPhone.text,
                  aadharBack: '',
                  aadharFront: '',
                  createdDate: DateTimeFormatter.now(),
                  email: '',
                  pan: '',
                  status: UserStatus.CREATED.name,
                  updatedDate: DateTimeFormatter.now(),
                  userType: UserType.Customer.name,
                  vpa: '',
                  isKycVerified: false,
                  image: '',
                  referralCode: getRandomString(6),
                );
                _api.createUser(model).then((value) {
                  loadScreen();
                });
                Navigator.of(context).pop();
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }
}
