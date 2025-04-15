import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_project/customer/pages/my_vehicles_page.dart';
import 'package:flutter_project/customer/pages/new_vehicle_page.dart';
import 'package:flutter_project/theme/theme.dart';
import 'package:flutter_project/utils.dart';
import 'package:flutter_project/vehicle/vehicle.dart';

import 'package:provider/provider.dart';
import 'package:flutter_project/theme/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  inspect(prefs);

  bool isDarkMode =
      prefs.getBool('isDarkMode') ?? ThemeMode.system == ThemeMode.dark;

  await Vehicle.loadFromLocal();

  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(isDarkMode),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Car Insurance App',
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: HomePage(),
    );
  }
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _MyLoginState();
}

class _MyLoginState extends State<Login> {
  TextEditingController usernameTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Login',
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        Container(
          height: 10,
        ),
        TextField(
          controller: usernameTextEditingController,
          keyboardType: TextInputType.name,
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Username:',
              icon: Icon(Icons.person)),
        ),
        Container(
          height: 20,
        ),
        TextField(
          controller: passwordTextEditingController,
          obscureText: true,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password:',
              icon: Icon(Icons.password)),
        ),
        Container(
          height: 20,
        ),
        MaterialButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          },
          child: const Text('login'),
        )
      ],
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      default:
        page = const Placeholder();
    }

    return SafeArea(
      child: Scaffold(
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
          alignment: Alignment.topCenter,
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
          ],
          selectedIndex: selectedIndex,
          onDestinationSelected: (value) {
            setState(() {
              selectedIndex = value;
            });
          },
        ),
      ),
    );
  }
}
