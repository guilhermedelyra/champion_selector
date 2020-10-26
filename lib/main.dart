import 'package:flutter/material.dart';
import 'loading.dart';
import 'home.dart';
import 'user_preferences.dart';

void main() async {
  var mapp;
  var routes = <String, WidgetBuilder>{
    '/loading': (BuildContext context) => Loading(),
    '/home': (BuildContext context) => Home(),
  };
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesClass.restore("hasInstalledFilesForTheFirstTime")
      .then((value) {
    if (value) {
      mapp = MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Champion Selector',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: routes,
        home: Home(),
      );
    } else {
      mapp = MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Champion Selector',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: routes,
        home: Loading(),
      );
    }
  });
  runApp(mapp);
}
