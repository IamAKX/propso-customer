import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/list/property_list.dart';
import '../../models/user_model.dart';
import '../../services/api_service.dart';
import '../../services/snakbar_service.dart';
import '../../utils/preference_key.dart';
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
    return ListView.builder(
      itemCount: propertyListModel?.data?.length ?? 0,
      itemBuilder: (context, index) => PropertyCard(
        property: propertyListModel?.data?.elementAt(index),
        reload: loadScreen,
      ),
    );
  }
}
