import 'package:flutter/material.dart';
import 'package:flutter_project/theme/theme.dart';
import 'package:flutter_project/theme/theme_provider.dart';
import 'package:provider/provider.dart';

AppBar appBar(context, title) => AppBar(
      title: Padding(
        padding: const EdgeInsets.only(top: 20, left: 20),
        child: Text(title, style: Theme.of(context).textTheme.titleLarge),
      ),
      actions: [
        Padding(
            padding: const EdgeInsets.only(top: 20, right: 20),
            child: Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
              return IconButton(
                onPressed: () {
                  Provider.of<ThemeProvider>(context, listen: false)
                      .toggleTheme();
                },
                icon: Provider.of<ThemeProvider>(context).themeData == lightMode
                    ? Icon(Icons.light_mode)
                    : Icon(Icons.dark_mode),
              );
            })),
      ],
    );
