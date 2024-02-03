import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:propertycp_customer/utils/theme.dart';
import 'package:propertycp_customer/widgets/gaps.dart';
import 'package:propertycp_customer/widgets/responsive.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../services/api_service.dart';
import '../../services/snakbar_service.dart';
import '../../utils/preference_key.dart';

class EnquiryScreen extends StatefulWidget {
  const EnquiryScreen({super.key, required this.propertyId});
  final int propertyId;
  static const String routePath = '/enquiryScreenRoute';

  @override
  State<EnquiryScreen> createState() => _EnquiryScreenState();
}

class _EnquiryScreenState extends State<EnquiryScreen> {
  UserModel? userModel;
  late ApiProvider _api;
  final TextEditingController _messageCtrl = TextEditingController();

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
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enquiry'),
      ),
      body: Padding(
        padding: Responsive.isDesktop(context)
            ? EdgeInsets.symmetric(
                vertical: defaultPadding,
                horizontal: MediaQuery.of(context).size.width * 0.2)
            : const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: _messageCtrl,
                maxLines: 30,
                decoration: const InputDecoration(
                  hintText: 'What do you want to enquire?',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            verticalGap(defaultPadding),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (userModel == null || _messageCtrl.text.isEmpty) {
                    SnackBarService.instance
                        .showSnackBarError('Enter enquiry message');
                    return;
                  }
                  _api
                      .sendEnquiryEmail(
                          userModel!, _messageCtrl.text, widget.propertyId)
                      .then((value) {
                    if (value) {
                      Navigator.pop(context);
                    }
                  });
                },
                child: const Text('Send'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
