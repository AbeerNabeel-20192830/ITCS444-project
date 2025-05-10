import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/authentication.dart';
import 'package:flutter_project/components/custom_snackbar.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Login into your account',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 30,
          ),
          TextField(
            controller: email,
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
                icon: Icon(Icons.person)),
          ),
          Container(
            height: 20,
          ),
          TextField(
            controller: password,
            obscureText: true,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
                icon: Icon(Icons.password)),
          ),
          Container(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                // Call the login method from the Authentication class
                await context.read<Authentication>().login(
                      email.text.trim(),
                      password.text,
                    );
                // Navigate to the home screen or show a success message
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(snackBar('Login successful',
                      'Welcome, ${email.text}!', ContentType.success));
              } catch (e) {
                // Show an error message if login fails
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                      snackBar('Login failed', '$e', ContentType.failure));
              }
            },
            child: const Text('Log in'),
          )
        ],
      ),
    );
  }
}
