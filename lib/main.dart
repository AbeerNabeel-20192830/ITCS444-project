import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/admin/offers/offer_provider.dart';
import 'package:flutter_project/authentication.dart';
import 'package:flutter_project/api_keys.dart';
import 'package:flutter_project/admin/admin_view.dart';
import 'package:flutter_project/customer/user_view.dart';
import 'package:flutter_project/models/accident_provider.dart';
import 'package:flutter_project/models/insurance_provider.dart';
import 'package:flutter_project/models/vehicle_provider.dart';
import 'package:flutter_project/non_logged_view.dart';
import 'package:provider/provider.dart';
import 'package:flutter_project/theme/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isDarkMode =
      prefs.getBool('isDarkMode') ?? ThemeMode.system == ThemeMode.dark;

  await Firebase.initializeApp(options: myFirebaseOptions);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ThemeProvider(isDarkMode)),
      ChangeNotifierProvider(create: (context) => Authentication()),
      ChangeNotifierProvider(create: (context) => OfferProvider()),
      ChangeNotifierProvider(
        create: (context) => InsuranceProvider(
          uid: FirebaseAuth.instance.currentUser!.uid,
          offerProvider: context.read<OfferProvider>(),
          isAdmin: context.read<Authentication>().isAdmin,
        ),
      ),
      ChangeNotifierProvider(
        create: (context) => VehicleProvider(
          uid: FirebaseAuth.instance.currentUser!.uid,
          isAdmin: context.read<Authentication>().isAdmin,
        ),
      ),
      ChangeNotifierProvider(
        create: (context) => AccidentProvider(
          uid: FirebaseAuth.instance.currentUser!.uid,
          isAdmin: context.read<Authentication>().isAdmin,
        ),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Car Insurance App',
      theme: themeProvider.themeData,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            // User is logged in
            if (context.read<Authentication>().isAdmin) {
              return const AdminView();
            }
            return const UserView();
          } else {
            // User is not logged in
            return const NonLoggedInView();
          }
        },
      ),
    );
  }
}
