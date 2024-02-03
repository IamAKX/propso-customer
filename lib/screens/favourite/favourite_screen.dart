import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:propertycp_customer/widgets/gaps.dart';
import 'package:propertycp_customer/widgets/responsive.dart';
import 'package:provider/provider.dart';

import '../../models/list/property_list.dart';
import '../../models/user_model.dart';
import '../../services/api_service.dart';
import '../../services/snakbar_service.dart';
import '../../utils/preference_key.dart';
import '../../utils/theme.dart';
import '../../widgets/no_property_found.dart';
import '../../widgets/property_card.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key, required this.switchTabs});
  final Function(int index) switchTabs;
  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  UserModel? userModel;
  late ApiProvider _api;
  PropertyListModel? propertyListModel;

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

      propertyListModel =
          await _api.getAllFavProperties(SharedpreferenceKey.getAllFavIds());

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favourite'),
        actions: Responsive.isDesktop(context)
            ? [
                TextButton(
                  onPressed: () {
                    widget.switchTabs(0);
                  },
                  child: const Text('Home'),
                ),
                horizontalGap(20),
                TextButton(
                  onPressed: () {
                    widget.switchTabs(2);
                  },
                  child: const Text('Profile'),
                ),
                horizontalGap(40),
              ]
            : [],
      ),
      body: _api.status == ApiStatus.loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : getBody(context),
    );
  }

  getBody(BuildContext context) {
    if (propertyListModel?.data?.isEmpty ?? true) {
      return const NoPropertyFound();
    }
    return Responsive(
      mobile: ListView.builder(
        itemCount: propertyListModel?.data?.length ?? 0,
        itemBuilder: (context, index) => PropertyCard(
          property: propertyListModel?.data?.elementAt(index),
          reload: loadScreen,
        ),
      ),
      desktop: Container(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.2),
        child: Scrollbar(
          child: GridView.count(
            crossAxisCount: 3,
            padding: const EdgeInsets.all(defaultPadding / 2),
            shrinkWrap: true,
            mainAxisSpacing: defaultPadding / 2,
            crossAxisSpacing: defaultPadding / 2,
            children: propertyListModel!.data!
                .map(
                  (e) => PropertyCard(
                    property: e,
                    reload: loadScreen,
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
