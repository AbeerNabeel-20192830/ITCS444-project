import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

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
          controller: username,
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
          controller: password,
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
        ElevatedButton(
          onPressed: () {},
          child: const Text('Log in'),
        )
      ],
    );
  }
}
