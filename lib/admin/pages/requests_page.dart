import 'package:flutter/material.dart';
import 'package:flutter_project/admin/insurance/insurance_request_list.dart';

class InsuranceRequestsPage extends StatefulWidget {
  const InsuranceRequestsPage({super.key});

  @override
  State<InsuranceRequestsPage> createState() => _InsuranceRequestsPageState();
}

class _InsuranceRequestsPageState extends State<InsuranceRequestsPage> {
  @override
  Widget build(BuildContext context) {
    return InsuranceRequestList();
  }
}
