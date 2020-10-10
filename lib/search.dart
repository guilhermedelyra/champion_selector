import 'package:flutter/material.dart';

class SecondRoute extends StatelessWidget {
  final int i;
  SecondRoute({Key key, @required this.i}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route $i"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}
