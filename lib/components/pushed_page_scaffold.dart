import 'package:flutter/material.dart';
import 'package:flutter_project/utils.dart';

class PushedPageScaffold extends StatefulWidget {
  Widget? page;
  String? title;
  PushedPageScaffold({
    super.key,
    this.page,
    this.title,
  });

  @override
  State<PushedPageScaffold> createState() => _PushedPageScaffoldState();
}

class _PushedPageScaffoldState extends State<PushedPageScaffold> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title!,
              style: Theme.of(context).textTheme.titleSmall),
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: maxWidth,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: SizedBox(
                  width: maxWidth,
                  child: SingleChildScrollView(child: widget.page)),
            ),
          ),
        ),
      ),
    );
  }
}
