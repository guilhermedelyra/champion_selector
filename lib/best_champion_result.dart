import 'package:flutter/material.dart';
import 'style.dart';

class BestChampion extends StatefulWidget {
  final List orderedChampions;
  final String title;
  const BestChampion({Key key, this.orderedChampions, this.title})
      : super(key: key);

  @override
  _BestChampionState createState() => new _BestChampionState();
}

class _BestChampionState extends State<BestChampion> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List items = widget.orderedChampions.where((i) => i[1] != 0.0).toList();
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: bgdarkColor,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                width: 500,
                child: Scrollbar(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        trailing: new ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0),
                          ),
                          child: Image.network(
                              'http://ddragon.leagueoflegends.com/cdn/10.16.1/img/champion/${items[index][0]}.png',
                              width: 32,
                              height: 32,
                              fit: BoxFit.fill),
                        ),
                        title: Text(items[index][0], style: subtitleStyle),
                        subtitle: Text(items[index][1].toStringAsFixed(4) + '%',
                            style: getStyle(items[index][1])),
                      );
                    },
                  ),
                ),
              ),
            ),
            RaisedButton(
              color: Colors.red,
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
              child: Text('Go back!', style: chosenStyle),
            ),
          ],
        ),
      ),
    );
  }
}
