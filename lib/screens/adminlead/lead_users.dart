import 'package:flutter/material.dart';
import 'package:propertycp_customer/screens/adminlead/lead_list.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../services/api_service.dart';
import '../../services/snakbar_service.dart';
import '../../utils/colors.dart';
import '../../utils/preference_key.dart';
import '../../widgets/user_profile_image.dart';

class AllLeadUserScreen extends StatefulWidget {
  const AllLeadUserScreen({super.key});
  static const String routePath = '/allLeadUserScreen';

  @override
  State<AllLeadUserScreen> createState() => _AllLeadUserScreenState();
}

class _AllLeadUserScreenState extends State<AllLeadUserScreen> {
  UserModel? userModel;
  late ApiProvider _api;
  Map<UserModel, int>? userMap;

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
      userMap = await _api.getAllLeads();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('CP'),
        actions: [],
      ),
      body: SafeArea(
        child: getBody(context),
      ),
    );
  }

  getBody(BuildContext context) {
    if (_api.status == ApiStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (userMap?.keys.isEmpty ?? true) {
      return const Center(
        child: Text('No lead found'),
      );
    }
    return Expanded(
      child: ListView.separated(
        itemCount: userMap?.keys.length ?? 0,
        separatorBuilder: (context, index) => Divider(color: dividerColor),
        itemBuilder: (context, index) {
          return ListTile(
            leading: Stack(
              children: [
                ClipOval(
                  child: UserProfileImage(
                    userModel: userMap?.keys.elementAt(index),
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
                        (userMap?.keys.elementAt(index).isKycVerified ?? false)
                            ? Colors.green
                            : Colors.red,
                  ),
                ),
              ],
            ),
            title: Text(
              userMap?.keys.elementAt(index).fullName ?? '',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            trailing: const Icon(Icons.chevron_right),
            subtitle: Row(
              children: [
                Text(
                  'Leads created : ${userMap?.values.elementAt(index)}',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(),
                ),
                const Spacer(),
              ],
            ),
            onTap: () => Navigator.of(context)
                .pushNamed(AdminLeadList.routePath,
                    arguments: userMap?.keys.elementAt(index).id)
                .then((value) => loadScreen()),
          );
        },
      ),
    );
  }
}
