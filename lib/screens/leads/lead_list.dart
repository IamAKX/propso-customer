import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:propertycp_customer/models/leads_model.dart';
import 'package:propertycp_customer/models/list/lead_list.dart';
import 'package:propertycp_customer/models/property_short_model.dart';
import 'package:propertycp_customer/screens/leads/lead_comment.dart';
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
import 'create_lead.dart';

class LeadList extends StatefulWidget {
  const LeadList({super.key, required this.status});
  final String status;

  @override
  State<LeadList> createState() => _LeadListState();
}

class _LeadListState extends State<LeadList> {
  UserModel? userModel;
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
    _api.getUserById(SharedpreferenceKey.getUserId()).then((value) async {
      userModel = value;
      leadListModel = await _api.getAllLeadsByUserId(userModel?.id ?? -1);
      leadListModel?.data
          ?.retainWhere((element) => element.status == widget.status);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
        ),
        onPressed: () {
          PropertyShortModel propertyShortModel =
              PropertyShortModel(propertyId: 0, type: '');
          Navigator.pushNamed(context, CreateLead.routePath,
                  arguments: propertyShortModel)
              .then((value) {
            loadScreen();
          });
        },
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
              subtitle: Text(
                DateTimeFormatter.timesAgo(
                    leadListModel?.data?.elementAt(index).updatedDate ?? ''),
                style: Theme.of(context).textTheme.bodySmall,
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
                  (widget.status == LeadStatus.OPEN.name)
                      ? IconButton(
                          onPressed: () {
                            showCloseDialog(
                                context, leadListModel!.data!.elementAt(index));
                          },
                          icon: const Icon(
                            Icons.close,
                            color: Colors.red,
                          ),
                        )
                      : IconButton(
                          onPressed: () {
                            showReopenDialog(
                                context, leadListModel!.data!.elementAt(index));
                          },
                          icon: const Icon(
                            Icons.replay,
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
}
