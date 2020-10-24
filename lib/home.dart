import 'package:flutter/material.dart';
import 'package:champion_selector/search.dart';
import 'package:champion_selector/loading.dart';
import 'style.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  initState() {
    // _initStarCore();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0.0,
              right: 0.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: new IconButton(
                    icon: Icon(
                      Icons.refresh,
                      color: Colors.lightBlueAccent,
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Loading()));
                    }),
              ),
            ),
            app(context),
          ],
        ),
      ),
    );
  }
}

Widget app(BuildContext context) {
  return Column(
    children: <Widget>[
      Expanded(
          child: renderColumn(
        _buildContainer(roleIcon(Colors.purpleAccent, "top"), 'Top', context),
        _buildContainer(roleIcon(Colors.green, "jungle"), 'Jungle', context),
      )),
      _buildContainer(roleIcon(Colors.redAccent, "mid"), 'Middle', context),
      Expanded(
          child: renderColumn(
        _buildContainer(roleIcon(Colors.cyanAccent, "adc"), 'ADC', context),
        _buildContainer(
            roleIcon(Colors.yellowAccent, "sup"), 'Support', context),
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

Widget roleIcon(color, role) {
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
      Align(alignment: Alignment.center, child: box(title, icon, context)),
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

Widget box(title, icon, context) {
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AutoComplete(role: title)),
                ),
              }, // handle your onTap here
          child: icon),
    ),
  );
}
