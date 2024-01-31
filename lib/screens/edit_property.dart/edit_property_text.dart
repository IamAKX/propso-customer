import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:propertycp_customer/models/property_model.dart';
import 'package:propertycp_customer/screens/edit_property.dart/edit_property_image.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../services/api_service.dart';
import '../../services/snakbar_service.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/preference_key.dart';
import '../../utils/theme.dart';
import '../../widgets/gaps.dart';

class EditPropertyText extends StatefulWidget {
  const EditPropertyText({super.key, required this.propertyId});
  static const String routePath = '/editPropertyText';
  final int propertyId;

  @override
  State<EditPropertyText> createState() => _EditPropertyTextState();
}

class _EditPropertyTextState extends State<EditPropertyText> {
  UserModel? userModel;
  late ApiProvider _api;
  PropertyModel? propertyModel;

  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _subTitleCtrl = TextEditingController();
  final TextEditingController _priceCtrl = TextEditingController();
  final TextEditingController _bhkCtrl = TextEditingController();
  final TextEditingController _areaCtrl = TextEditingController();
  final TextEditingController _builderPhoneCtrl = TextEditingController();
  final TextEditingController _descriptionCtrl = TextEditingController();
  String? selectedPropertyType;
  String? selectedAreaType;
  String? selectedCity;

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
      _titleCtrl.text = propertyModel?.title ?? '';
      _subTitleCtrl.text = propertyModel?.subTitle ?? '';
      _priceCtrl.text = propertyModel?.price ?? '';
      _bhkCtrl.text = propertyModel?.bhk ?? '';
      _builderPhoneCtrl.text = propertyModel?.builderPhoneNumber ?? '';
      _areaCtrl.text = propertyModel?.area ?? '';
      _descriptionCtrl.text = propertyModel?.description ?? '';
      selectedPropertyType = propertyModel?.type ?? '';
      selectedAreaType = propertyModel?.areaUnit ?? '';
      selectedCity = propertyModel?.city ?? '';
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Property'),
        actions: [
          TextButton(
            onPressed: () {
              if (!isValidInput()) {
                return;
              }
              propertyModel?.title = _titleCtrl.text;
              propertyModel?.subTitle = _subTitleCtrl.text;
              propertyModel?.price = _priceCtrl.text;
              propertyModel?.bhk = _bhkCtrl.text;
              propertyModel?.area = _areaCtrl.text;
              propertyModel?.areaUnit = selectedAreaType;
              propertyModel?.city = selectedCity;
              propertyModel?.type =
                  selectedPropertyType == 'Commercial Properties'
                      ? 'CommercialProperties'
                      : selectedPropertyType;
              propertyModel?.description = _descriptionCtrl.text;

              _api
                  .updatePropety(
                      propertyModel?.toMap() ?? {}, propertyModel!.id!)
                  .then((value) {
                if (value) {
                  SnackBarService.instance.showSnackBarSuccess('Updated');
                  Navigator.pushNamed(context, EditPropertyImage.routePath,
                      arguments: widget.propertyId);
                }
              });
            },
            child: Text(
              'Next',
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: Colors.white),
            ),
          ),
        ],
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
        TextField(
          controller: _titleCtrl,
          keyboardType: TextInputType.name,
          decoration: const InputDecoration(
            hintText: 'Title : To be displayed in bold',
            label: Text('Title'),
          ),
        ),
        verticalGap(defaultPadding / 2),
        TextField(
          controller: _subTitleCtrl,
          keyboardType: TextInputType.name,
          decoration: const InputDecoration(
            hintText: 'Subtitle : One liner about the property',
            label: Text('Subtitle'),
          ),
        ),
        verticalGap(defaultPadding / 2),
        TextField(
          controller: _priceCtrl,
          keyboardType: TextInputType.name,
          decoration: const InputDecoration(
            hintText: 'Price : Eg. 1.2 Cr or 85 lacs',
            label: Text('Price'),
          ),
        ),
        verticalGap(defaultPadding / 2),
        TextField(
          controller: _bhkCtrl,
          keyboardType: TextInputType.name,
          decoration: const InputDecoration(
            hintText: 'BHK : Eg. 3 BHK or 1 RK',
            label: Text('BHK'),
          ),
        ),
        verticalGap(defaultPadding / 2),
        TextField(
          maxLength: 10,
          controller: _builderPhoneCtrl,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            hintText: 'Enter 10 digit phone number',
            label: Text('Builder Phone Number'),
          ),
        ),
        verticalGap(defaultPadding / 2),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              flex: 4,
              child: TextField(
                controller: _areaCtrl,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  hintText: 'Area : Eg. 1 or 1490.5',
                  label: Text('Area'),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  value: selectedAreaType,
                  underline: null,
                  isExpanded: true,
                  barrierLabel: 'Area Unit',
                  hint: Text(
                    'Select Unit',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  items:
                      ['Sqft', 'Sqyard', 'Gunta', 'Acre'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedAreaType = value;
                    });
                  },
                ),
              ),
            )
          ],
        ),
        verticalGap(defaultPadding),
        DropdownButton2<String>(
          underline: const Divider(
            height: 1.6,
            color: hintColor,
            thickness: 1,
          ),
          value: selectedCity,
          isExpanded: true,
          barrierLabel: 'Select City',
          hint: Text(
            'Select City',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).hintColor,
            ),
          ),
          items: karnatakaDistricts.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedCity = value;
            });
          },
        ),
        verticalGap(defaultPadding),
        DropdownButton2<String>(
          underline: const Divider(
            height: 1.6,
            color: hintColor,
            thickness: 1,
          ),
          value: selectedPropertyType,
          isExpanded: true,
          barrierLabel: 'Select Property Type',
          hint: Text(
            'Select Property Type',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).hintColor,
            ),
          ),
          items: propertyTypeName.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedPropertyType = value;
            });
          },
        ),
        verticalGap(defaultPadding / 2),
        TextField(
          controller: _descriptionCtrl,
          maxLines: 3,
          maxLength: 500,
          keyboardType: TextInputType.name,
          decoration: const InputDecoration(
            alignLabelWithHint: true,
            hintText: 'Description',
            label: Text('Description'),
          ),
        ),
        verticalGap(defaultPadding),
      ],
    );
  }

  isValidInput() {
    if (_titleCtrl.text.isEmpty ||
        _subTitleCtrl.text.isEmpty ||
        _priceCtrl.text.isEmpty ||
        _bhkCtrl.text.isEmpty ||
        _areaCtrl.text.isEmpty ||
        _descriptionCtrl.text.isEmpty ||
        (selectedPropertyType?.isEmpty ?? true) ||
        (selectedAreaType?.isEmpty ?? true) ||
        (selectedCity?.isEmpty ?? true)) {
      SnackBarService.instance.showSnackBarError('All Fields are mandatory');
      return false;
    }

    return true;
  }
}
