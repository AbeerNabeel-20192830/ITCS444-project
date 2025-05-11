import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/authentication.dart';
import 'package:flutter_project/components/custom_snackbar.dart';
import 'package:flutter_project/theme/theme.dart';
import 'package:flutter_project/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  User user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: ListTile(
            title: Text("App Theme"),
            trailing: IconButton(
                onPressed: () {
                  context.read<ThemeProvider>().toggleTheme();
                },
                icon: context.watch<ThemeProvider>().themeData == lightMode
                    ? Icon(Icons.light_mode)
                    : Icon(Icons.dark_mode)),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            try {
              // Call the login method from the Authentication class
              await context.read<Authentication>().logout();
              // Navigate to the home screen or show a success message
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(snackBar('Logged out successfully',
                    'See you later, ${user.email}!', ContentType.success));
            } catch (e) {
              // Show an error message if login fails
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                    snackBar('Logging out failed', '$e', ContentType.failure));
            }
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError),
          child: Text(
            'Sign Out',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
