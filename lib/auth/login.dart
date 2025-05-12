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

class _LoginState extends State<Login> with TickerProviderStateMixin {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  // Animation controllers
  late AnimationController _titleController;
  late Animation<Offset> _titleSlide;
  late Animation<double> _titleFade;
  late AnimationController _shakeController;

  bool isLoading = false;
  bool shake = false;

  @override
  void initState() {
    super.initState();

    _titleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    );
    _titleSlide =
        Tween<Offset>(begin: Offset(0, -0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _titleController, curve: Curves.easeOut),
    );
    _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _titleController, curve: Curves.easeIn),
    );
    _titleController.forward();

    _shakeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _shakeController.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SlideTransition(
            position: _titleSlide,
            child: FadeTransition(
              opacity: _titleFade,
              child: const Text(
                'Login into your account',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(height: 30),
          TextField(
            controller: email,
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Email',
              icon: Icon(Icons.person),
            ),
          ),
          Container(height: 20),
          TextField(
            controller: password,
            obscureText: true,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password',
              icon: Icon(Icons.password),
            ),
          ),
          Container(height: 20),
          AnimatedBuilder(
            animation: _shakeController,
            builder: (context, child) {
              final offset = shake
                  ? Tween<Offset>(
                      begin: Offset.zero,
                      end: Offset(0.03, 0),
                    )
                      .chain(CurveTween(curve: Curves.elasticIn))
                      .animate(_shakeController)
                      .value
                  : Offset.zero;

              return Transform.translate(
                offset: offset * MediaQuery.of(context).size.width,
                child: child,
              );
            },
            child: ElevatedButton(
              onPressed: () async {
                setState(() {
                  isLoading = true;
                  shake = false;
                });

                try {
                  // Call the login method from the Authentication class
                  await context.read<Authentication>().login(
                        email.text.trim(),
                        password.text,
                      );
                  // Navigate to the home screen or show a success message
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(snackBar(
                      'Login successful',
                      'Welcome, ${email.text}!',
                      ContentType.success,
                    ));
                } catch (e) {
                  // Show an error message if login fails
                  _shakeController.forward(from: 0);
                  setState(() {
                    shake = true;
                  });

                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(snackBar(
                      'Login failed',
                      '$e..',
                      ContentType.failure,
                    ));
                } finally {
                  setState(() {
                    isLoading = false;
                  });
                }
              },
              child: isLoading
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Log in'),
            ),
          ),
        ],
      ),
    );
  }
}
