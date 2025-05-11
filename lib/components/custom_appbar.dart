import 'package:flutter/material.dart';
import 'package:flutter_project/components/pushed_page_scaffold.dart';
import 'package:flutter_project/notifications_page.dart';

AppBar appBar(context, title) => AppBar(
      title: Text(title, style: Theme.of(context).textTheme.titleLarge),
      actions: [
        IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PushedPageScaffold(
                          page: NotificationsPage(), title: "Notifications")));
            },
            icon: Icon(Icons.notifications))
      ],
    );
