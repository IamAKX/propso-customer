import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../models/user_model.dart';
import '../../../services/api_service.dart';
import '../../../services/snakbar_service.dart';
import '../../../services/storage_service.dart';
import '../../../utils/colors.dart';
import '../../../utils/preference_key.dart';
import '../../../utils/theme.dart';
import '../../../widgets/gaps.dart';

class KycScreen extends StatefulWidget {
  const KycScreen({super.key});
  static const String routePath = '/kycScreen';
  @override
  State<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends State<KycScreen> {
  File? aadhaarFront, aadhaarBack, pan;
  final TextEditingController upiVpa = TextEditingController();

  UserModel? userModel;
  late ApiProvider _api;
  late StorageProvider _storageProvider;
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
        title: const Text('KYC'),
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(defaultPadding),
      children: [
        TextField(
          controller: upiVpa,
          keyboardType: TextInputType.name,
          decoration: const InputDecoration(
            hintText: 'Enter UPI VPA',
            label: Text('Upi VPA'),
          ),
        ),
        verticalGap(defaultPadding),
        verticalGap(defaultPadding),
        Text(
          'Aadhaar Front',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        verticalGap(defaultPadding / 2),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: hintColor.withOpacity(0.5),
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          alignment: Alignment.center,
          height: 200,
          width: double.infinity,
          child: aadhaarFront != null
              ? Stack(
                  children: [
                    Image.file(
                      aadhaarFront!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                    ),
                    IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.camera);
                        if (image != null) {
                          setState(() {
                            aadhaarFront = File(image.path);
                          });
                        }
                      },
                      icon: const Icon(Icons.camera_alt),
                    ),
                  ],
                )
              : InkWell(
                  onTap: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image =
                        await picker.pickImage(source: ImageSource.camera);
                    if (image != null) {
                      setState(() {
                        aadhaarFront = File(image.path);
                      });
                    }
                  },
                  child: const Icon(
                    LineAwesomeIcons.camera,
                    size: 60,
                    color: Colors.grey,
                  ),
                ),
        ),
        verticalGap(defaultPadding),
        Text(
          'Aadhaar Back',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        verticalGap(defaultPadding / 2),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: hintColor.withOpacity(0.5),
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          alignment: Alignment.center,
          height: 200,
          width: double.infinity,
          child: aadhaarBack != null
              ? Stack(
                  children: [
                    Image.file(
                      aadhaarBack!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                    ),
                    IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.camera);
                        if (image != null) {
                          setState(() {
                            aadhaarBack = File(image.path);
                          });
                        }
                      },
                      icon: const Icon(Icons.camera_alt),
                    ),
                  ],
                )
              : InkWell(
                  onTap: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image =
                        await picker.pickImage(source: ImageSource.camera);
                    if (image != null) {
                      setState(() {
                        aadhaarBack = File(image.path);
                      });
                    }
                  },
                  child: const Icon(
                    LineAwesomeIcons.camera,
                    size: 60,
                    color: Colors.grey,
                  ),
                ),
        ),
        verticalGap(defaultPadding),
        Text(
          'PAN Card',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        verticalGap(defaultPadding / 2),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: hintColor.withOpacity(0.5),
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          alignment: Alignment.center,
          height: 200,
          width: double.infinity,
          child: pan != null
              ? Stack(
                  children: [
                    Image.file(
                      pan!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                    ),
                    IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.camera);
                        if (image != null) {
                          setState(() {
                            pan = File(image.path);
                          });
                        }
                      },
                      icon: const Icon(Icons.camera_alt),
                    ),
                  ],
                )
              : InkWell(
                  onTap: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image =
                        await picker.pickImage(source: ImageSource.camera);
                    if (image != null) {
                      setState(() {
                        pan = File(image.path);
                      });
                    }
                  },
                  child: const Icon(
                    LineAwesomeIcons.camera,
                    size: 60,
                    color: Colors.grey,
                  ),
                ),
        ),
        verticalGap(defaultPadding),
        ElevatedButton(
          onPressed: _storageProvider.status == StorageStatus.loading
              ? null
              : () {
                  if (upiVpa.text.isEmpty ||
                      aadhaarFront == null ||
                      aadhaarBack == null ||
                      pan == null) {
                    SnackBarService.instance
                        .showSnackBarError('All fields are mandatory');
                    return;
                  }
                  SnackBarService.instance
                      .showSnackBarInfo('Uploading images, please wait...');
                  userModel?.vpa = upiVpa.text;
                  _storageProvider
                      .uploadKycImage(
                          aadhaarFront!, aadhaarBack!, pan!, userModel)
                      .then((value) {
                    if (value?.aadharBack?.isNotEmpty ?? false) {
                      SnackBarService.instance.showSnackBarSuccess(
                          'KYC verification request submitted');
                      Navigator.pop(context);
                    }
                  });
                },
          child: Text(_storageProvider.status == StorageStatus.loading
              ? 'Uploading images, please wait...'
              : 'Submit'),
        )
      ],
    );
  }
}
