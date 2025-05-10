import 'package:flutter/material.dart';
import 'package:flutter_project/customer/pages/accident_report.dart';
import 'package:flutter_project/customer/pages/my_vehicles_page.dart';
import 'package:flutter_project/customer/pages/new_vehicle_page.dart';
import 'package:flutter_project/settings_page.dart';
import 'package:flutter_project/theme/theme.dart';
import 'package:flutter_project/theme/theme_provider.dart';
import 'package:flutter_project/utils.dart';
import 'package:provider/provider.dart';

class UserView extends StatefulWidget {
  const UserView({super.key});

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  var title = '';
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        title = 'New Vehicle';
        page = const NewVehiclePage();
        break;
      case 1:
        title = 'My Vehicles';
        page = const MyVehiclesPage();
        break;
      case 2:
        title = 'Report Accident';
        page = const AccidentReportPage();
        break;
      case 3:
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
              icon: Icon(Icons.add_circle), label: 'New Vehicle'),
          NavigationDestination(
              icon: Icon(Icons.directions_car), label: 'My Vehicles'),
          NavigationDestination(
              icon: Icon(Icons.car_crash), label: 'Report Accident'),
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
