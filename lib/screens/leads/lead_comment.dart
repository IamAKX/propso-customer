import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:propertycp_customer/models/lead_comment_model.dart';
import 'package:propertycp_customer/models/leads_model.dart';
import 'package:propertycp_customer/utils/colors.dart';
import 'package:propertycp_customer/utils/enum.dart';
import 'package:propertycp_customer/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/user_model.dart';
import '../../services/api_service.dart';
import '../../services/snakbar_service.dart';
import '../../utils/date_time_formatter.dart';
import '../../utils/preference_key.dart';

class LeadCommentScreen extends StatefulWidget {
  const LeadCommentScreen({super.key, required this.leadId});
  final int leadId;
  static const String routePath = '/leadCommentScreen';

  @override
  State<LeadCommentScreen> createState() => _LeadCommentScreenState();
}

class _LeadCommentScreenState extends State<LeadCommentScreen> {
  UserModel? userModel;
  late ApiProvider _api;
  LeadsModel? leadsModel;
  final TextEditingController _commentCtrl = TextEditingController();

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
      log(widget.leadId.toString());
      leadsModel = await _api.getLeadsById(widget.leadId);

      log(leadsModel.toString());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
        actions: [
          IconButton(
            onPressed: () {
              launchUrl(Uri.parse('tel://${leadsModel?.mobileNo ?? ''}'));
            },
            icon: Icon(Icons.call),
          ),
        ],
      ),
      body: SafeArea(
        child: getBody(context),
      ),
    );
  }

  getBody(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            reverse: true,
            itemCount: leadsModel?.leadCommentModel?.length ?? 0,
            separatorBuilder: (context, index) => Divider(color: dividerColor),
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                    leadsModel?.leadCommentModel?.elementAt(index).comment ??
                        ''),
                subtitle: Row(
                  children: [
                    Text(
                      leadsModel?.leadCommentModel?.elementAt(index).userType ??
                          '',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: (leadsModel?.leadCommentModel
                                            ?.elementAt(index)
                                            .userType ??
                                        '') ==
                                    UserType.Admin.name
                                ? secondary
                                : primary,
                          ),
                    ),
                    const Spacer(),
                    Text(
                      DateTimeFormatter.timesAgo(leadsModel?.leadCommentModel
                              ?.elementAt(index)
                              .timeStamp ??
                          ''),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: (leadsModel?.leadCommentModel
                                            ?.elementAt(index)
                                            .userType ??
                                        '') ==
                                    UserType.Admin.name
                                ? secondary
                                : primary,
                          ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
        const Divider(
          color: dividerColor,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentCtrl,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: 'Comment',
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                onPressed: _api.status == ApiStatus.loading
                    ? null
                    : () {
                        if (_commentCtrl.text.isEmpty) {
                          return;
                        }
                        LeadCommentModel comment = LeadCommentModel(
                            userType: userModel?.userType,
                            // timeStamp: DateTimeFormatter.now(),
                            comment: _commentCtrl.text);
                        leadsModel?.leadCommentModel = [comment];

                        log('${leadsModel?.toMap().toString()}');
                        _api
                            .updateLead(
                                leadsModel?.toMap() ?? {}, leadsModel?.id ?? -1)
                            .then((value) {
                          _commentCtrl.text = '';
                          loadScreen();
                        });
                      },
                icon: _api.status == ApiStatus.loading
                    ? const CircularProgressIndicator()
                    : const Icon(
                        Icons.send,
                        color: secondary,
                      ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
