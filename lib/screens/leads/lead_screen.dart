import 'package:flutter/material.dart';
import 'package:propertycp_customer/screens/leads/create_lead.dart';
import 'package:propertycp_customer/screens/leads/lead_list.dart';
import 'package:propertycp_customer/utils/enum.dart';

class LeadScreen extends StatefulWidget {
  const LeadScreen({super.key, required this.switchTabs});
  final Function(int index) switchTabs;
  @override
  State<LeadScreen> createState() => _LeadScreenState();
}

class _LeadScreenState extends State<LeadScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  GlobalKey tabViewKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // Number of tabs
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leads'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Open'),
            Tab(text: 'Closed'),
          ],
        ),
        actions: [],
      ),
      body: TabBarView(
        controller: _tabController,
        key: tabViewKey,
        children: [
          LeadList(status: LeadStatus.OPEN.name),
          LeadList(status: LeadStatus.CLOSE.name),
        ],
      ),
    );
  }
}
