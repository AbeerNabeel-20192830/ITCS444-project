import 'package:flutter/material.dart';
import 'package:flutter_project/auth/login.dart';
import 'package:flutter_project/auth/register.dart';
import 'package:flutter_project/theme/theme.dart';
import 'package:flutter_project/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class NonLoggedInView extends StatefulWidget {
  const NonLoggedInView({super.key});

  @override
  State<NonLoggedInView> createState() => _NonLoggedInViewState();
}

class _NonLoggedInViewState extends State<NonLoggedInView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Padding(
              padding: const EdgeInsets.only(
                top: 20,
                left: 20,
              ),
              child: Text('Car Insurance',
                  style: Theme.of(context).textTheme.titleLarge),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                  right: 20,
                ),
                child: IconButton(
                  onPressed: () {
                    Provider.of<ThemeProvider>(
                      context,
                      listen: false,
                    ).toggleTheme();
                  },
                  icon:
                      Provider.of<ThemeProvider>(context).themeData == lightMode
                          ? Icon(Icons.light_mode)
                          : Icon(Icons.dark_mode),
                ),
              ),
            ],
            bottom: const TabBar(tabs: [
              Tab(
                icon: Icon(Icons.login),
                child: Text('Login',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Tab(
                icon: Icon(Icons.person_add),
                child: Text('Register',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ]),
          ),
          body: TabBarView(children: [Login(), Register()])),
    );
  }
}
