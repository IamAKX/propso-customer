import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:propertycp_customer/models/leads_model.dart';
import 'package:propertycp_customer/models/list/lead_list.dart';
import 'package:propertycp_customer/screens/leads/lead_comment.dart';
import 'package:propertycp_customer/screens/property_listing/property_detail.dart';
import 'package:propertycp_customer/utils/colors.dart';
import 'package:propertycp_customer/utils/date_time_formatter.dart';
import 'package:propertycp_customer/utils/dummy.dart';
import 'package:propertycp_customer/utils/enum.dart';
import 'package:propertycp_customer/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/user_model.dart';
import '../../services/api_service.dart';
import '../../services/snakbar_service.dart';
import '../../utils/preference_key.dart';

class AdminLeadList extends StatefulWidget {
  const AdminLeadList({super.key, required this.userId});
  final int userId;
  static const String routePath = '/adminLeadList';

  @override
  State<AdminLeadList> createState() => _AdminLeadListState();
}

class _AdminLeadListState extends State<AdminLeadList> {
  late ApiProvider _api;
  LeadListModel? leadListModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => loadScreen(),
    );
  }

  loadScreen() async {
    leadListModel = await _api.getAllLeadsByUserId(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leads'),
        actions: [],
      ),
      body: getBody(context),
    );
  }

  void showCloseDialog(BuildContext context, LeadsModel lead) {
    lead.status = LeadStatus.CLOSE.name;
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.bottomSlide,
      autoDismiss: false,
      title: 'Close lead',
      desc: 'So you want to close this lead?',
      onDismissCallback: (type) {},
      btnCancelOnPress: () {
        Navigator.pop(context);
      },
      btnOkOnPress: () {
        _api.updateLead(lead.toMap(), lead.id ?? -1).then((value) {
          loadScreen();
        });
        Navigator.pop(context);
      },
    ).show();
  }

  void showReopenDialog(BuildContext context, LeadsModel lead) {
    lead.status = LeadStatus.OPEN.name;
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.bottomSlide,
      autoDismiss: false,
      title: 'Reopen lead',
      desc: 'So you want to reopen this lead?',
      onDismissCallback: (type) {},
      btnCancelOnPress: () {
        Navigator.pop(context);
      },
      btnOkOnPress: () {
        _api.updateLead(lead.toMap(), lead.id ?? -1).then((value) {
          loadScreen();
        });
        Navigator.pop(context);
      },
    ).show();
  }

  void showCommentDialog(BuildContext context, String comment) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.bottomSlide,
      title: 'Comment',
      body: Text(comment),
      padding: const EdgeInsets.all(defaultPadding),
      btnCancelOnPress: () {},
      btnOkOnPress: () {},
    ).show();
  }

  getBody(BuildContext context) {
    if (_api.status == ApiStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (leadListModel?.data?.isEmpty ?? true) {
      return const Center(
        child: Text('No lead found'),
      );
    }
    return ListView.separated(
        padding: const EdgeInsets.only(bottom: defaultPadding * 3),
        itemBuilder: (context, index) => ListTile(
              title: Text(leadListModel?.data?.elementAt(index).fullName ?? ''),
              subtitle: Row(
                children: [
                  Text(
                    DateTimeFormatter.timesAgo(
                        leadListModel?.data?.elementAt(index).updatedDate ??
                            ''),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '  |  ',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '${leadListModel?.data?.elementAt(index).status}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: getColorByStatus(
                            leadListModel?.data?.elementAt(index).status ??
                                '')),
                  ),
                ],
              ),
              onTap: () {
                Navigator.pushNamed(context, LeadCommentScreen.routePath,
                        arguments: leadListModel?.data?.elementAt(index).id)
                    .then((value) => loadScreen());
                // showCommentDialog(context,
                //     leadListModel?.data?.elementAt(index).comment ?? '');
              },
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      launchUrl(Uri.parse(
                          'tel://${leadListModel?.data?.elementAt(index).mobileNo ?? ''}'));
                    },
                    icon: const Icon(
                      Icons.call,
                      color: Colors.green,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showInfoPopup(
                          context, leadListModel?.data?.elementAt(index));
                    },
                    icon: const Icon(
                      Icons.info,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
        separatorBuilder: (context, index) =>
            const Divider(color: dividerColor),
        itemCount: leadListModel?.data?.length ?? 0);
  }

  void showInfoPopup(BuildContext context, LeadsModel? lead) {
    AlertDialog alert = AlertDialog(
      title: Text("Details"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Lead Type'),
              Text(
                lead?.leadPropertyType ?? '',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Property Type'),
              Text(
                lead?.propertyType ?? '',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              )
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Cancel',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: primary),
          ),
        ),
        if (lead?.propertyId != null && lead?.propertyId != 0)
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, PropertyDetailScreen.routePath,
                  arguments: lead?.propertyId);
            },
            child: Text(
              'View Property',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.blue),
            ),
          )
      ],
    );

    showDialog(
      context: context,
      builder: (context) => alert,
    );
  }
}
