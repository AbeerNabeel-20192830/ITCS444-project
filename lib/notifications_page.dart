import 'package:flutter/material.dart';
import 'package:flutter_project/authentication.dart';
import 'package:flutter_project/models/insurance.dart';
import 'package:flutter_project/models/insurance_provider.dart';
import 'package:provider/provider.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final List<String> notifications = [];

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  void removeNotification(int index) {
    final removedNotification = notifications[index];
    notifications.removeAt(index);

    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildNotificationItem(
        removedNotification,
        index,
        animation,
      ),
      duration: const Duration(milliseconds: 300),
    );
    setState(() {});
  }

  Widget _buildNotificationItem(
      String notification, int index, Animation<double> animation) {
    return SlideTransition(
      position: animation.drive(
        Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).chain(
          CurveTween(curve: Curves.easeInOut),
        ),
      ),
      child: Card(
        child: ListTile(
          title: Text(notification),
          trailing: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => removeNotification(index),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int pendingLength = context
        .watch<InsuranceProvider>()
        .insuranceList
        .where((ins) => ins.status == Status.pendingApproval)
        .toList()
        .length;

    if (context.read<Authentication>().isAdmin) {
      notifications.add(
          'You have $pendingLength pending insurance ${pendingLength == 1 ? 'request' : 'requests'}. Review ${pendingLength == 1 ? 'it' : 'them'} in the Insurance Requests page.');
    }
    return notifications.isEmpty
        ? const Center(
            child: Text(
              "You don't have any new notifications",
            ),
          )
        : AnimatedList(
            key: _listKey,
            initialItemCount: notifications.length,
            shrinkWrap: true,
            itemBuilder: (context, index, animation) {
              return _buildNotificationItem(
                  notifications[index], index, animation);
            },
          );
  }
}
