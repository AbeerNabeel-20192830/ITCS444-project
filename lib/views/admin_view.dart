import 'package:flutter/material.dart';
import 'package:flutter_project/admin/pages/requests_page.dart';
import 'package:flutter_project/settings_page.dart';
import 'package:flutter_project/theme/theme.dart';
import 'package:flutter_project/theme/theme_provider.dart';
import 'package:flutter_project/utils.dart';
import 'package:provider/provider.dart';

class AdminView extends StatefulWidget {
  const AdminView({super.key});

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  var title = '';
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        title = 'Insurance Requests';
        page = const InsuranceRequestsPage();
        break;
      case 1:
        title = 'Settings';
        page = const SettingsPage();
        break;
      default:
        page = const Placeholder();
    }
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 20, left: 20),
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 20, right: 20),
            child: IconButton(
              onPressed: () {
                Provider.of<ThemeProvider>(
                  context,
                  listen: false,
                ).toggleTheme();
              },
              icon: Provider.of<ThemeProvider>(context).themeData == lightMode
                  ? Icon(Icons.light_mode)
                  : Icon(Icons.dark_mode),
            ),
          ),
        ],
      ),
      body: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: maxWidth,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: page,
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.request_page), label: 'Insurance Requests'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        selectedIndex: selectedIndex,
        onDestinationSelected: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
      ),
    );
  }
}
