import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:propertycp_customer/models/property_model.dart';
import 'package:propertycp_customer/screens/profile/post_property/pick_propert_images.dart';
import 'package:propertycp_customer/services/snakbar_service.dart';
import 'package:propertycp_customer/utils/colors.dart';
import 'package:propertycp_customer/utils/theme.dart';
import 'package:string_validator/string_validator.dart';

import '../../../utils/constants.dart';
import '../../../widgets/gaps.dart';

class PostProperty extends StatefulWidget {
  const PostProperty({super.key});
  static const String routePath = '/postProperty';

  @override
  State<PostProperty> createState() => _PostPropertyState();
}

class _PostPropertyState extends State<PostProperty> {
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _subTitleCtrl = TextEditingController();
  final TextEditingController _priceCtrl = TextEditingController();
  final TextEditingController _bhkCtrl = TextEditingController();
  final TextEditingController _areaCtrl = TextEditingController();
  final TextEditingController _descriptionCtrl = TextEditingController();
  final TextEditingController _builderPropertyCtrl = TextEditingController();
  String? selectedPropertyType;
  String? selectedAreaType;
  String? selectedCity;

  PropertyModel model = PropertyModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Property'),
        actions: [
          TextButton(
            onPressed: () {
              if (!isValidInput()) {
                return;
              }
              model.title = _titleCtrl.text;
              model.subTitle = _subTitleCtrl.text;
              model.price = _priceCtrl.text;
              model.bhk = _bhkCtrl.text;
              model.builderPhoneNumber = _builderPropertyCtrl.text;
              model.area = _areaCtrl.text;
              model.areaUnit = selectedAreaType;
              model.city = selectedCity;
              model.type = selectedPropertyType == 'Commercial Properties'
                  ? 'CommercialProperties'
                  : selectedPropertyType;
              model.description = _descriptionCtrl.text;
              model.images = [];

              Navigator.pushReplacementNamed(
                  context, PickPropertyImages.routePath,
                  arguments: model);
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
      body: getBody(context),
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
          controller: _builderPropertyCtrl,
          keyboardType: TextInputType.phone,
          maxLength: 10,
          decoration: const InputDecoration(
            hintText: 'Enter 10 digit number',
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
        _builderPropertyCtrl.text.isEmpty ||
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
