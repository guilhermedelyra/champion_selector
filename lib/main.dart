import 'package:flutter/material.dart';
import 'package:champion_selector/search.dart';
import 'style.dart';

void main() {
  runApp(HomeScreen());
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Champion Selector',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgColor, body: Center(child: app(context)));
  }
}

Widget app(BuildContext context) {
  return Column(
    children: <Widget>[
      Expanded(
          child: renderColumn(
        _buildContainer(role_icon(Colors.purpleAccent, "top"), 'Top', context),
        _buildContainer(role_icon(Colors.green, "jungle"), 'Jungle', context),
      )),
      _buildContainer(role_icon(Colors.redAccent, "mid"), 'Mid', context),
      Expanded(
          child: renderColumn(
        _buildContainer(role_icon(Colors.cyanAccent, "adc"), 'ADC', context),
        _buildContainer(
            role_icon(Colors.yellowAccent, "sup"), 'Support', context),
      ))
    ],
  );
}

Widget renderColumn(widg1, widg2) {
  return Row(
    children: <Widget>[
      Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[widg1],
        ),
      ),
      Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[widg2],
        ),
      )
    ],
  );
}

Widget role_icon(color, role) {
  return SizedBox(
    height: 32,
    width: 32,
    child: Image.asset(
      'assets/icons/$role.png',
      color: color,
    ),
  );
}

Widget _buildContainer(icon, title, context) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Align(alignment: Alignment.center, child: box(icon, context)),
      Align(
        alignment: Alignment.center,
        child: Text(
          title,
          style: subtitleStyle,
          textAlign: TextAlign.center,
        ),
      ),
    ],
  );
}

Widget box(icon, context) {
  return Container(
    height: 100.0,
    width: 100.0,
    margin: EdgeInsets.only(bottom: 16.0),
    decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: lightColor.withOpacity(0.1),
            offset: Offset(-6, -6),
            spreadRadius: 0,
            blurRadius: 6,
          ),
          BoxShadow(
            color: Colors.black26,
            offset: Offset(6, 6),
            spreadRadius: 0,
            blurRadius: 6,
          )
        ]),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
          borderRadius: BorderRadius.circular(16),
          splashFactory: InkRipple.splashFactory,
          splashColor: bgdarkColor,
          highlightColor: Colors.transparent,
          onTap: () => {
                print("Container pressed"),
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SecondRoute(i: 5)),
                ),
              }, // handle your onTap here
          child: icon),
    ),
  );
}
