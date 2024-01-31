import 'package:flutter/material.dart';
import 'package:propertycp_customer/models/list/property_list.dart';
import 'package:propertycp_customer/widgets/no_property_found.dart';
import 'package:propertycp_customer/widgets/property_card.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../services/api_service.dart';
import '../../services/snakbar_service.dart';
import '../../utils/preference_key.dart';

class PropertyListingScreen extends StatefulWidget {
  const PropertyListingScreen({super.key, required this.params});
  final List<String?> params;
  static const String routePath = '/propertyListingScreen';

  @override
  State<PropertyListingScreen> createState() => _PropertyListingScreenState();
}

class _PropertyListingScreenState extends State<PropertyListingScreen> {
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
      String city = widget.params[0] ?? '';
      String type = widget.params[1] == 'Commercial Properties'
          ? 'CommercialProperties'
          : widget.params[1]!;
      propertyListModel = await _api.getAllProperties(city, type);

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.params.elementAt(1) ?? ''),
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
          reload: loadScreen),
    );
  }
}
