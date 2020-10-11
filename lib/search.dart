import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:champion_selector/champions.dart';
import 'style.dart';

// class SecondRoute extends StatelessWidget {
//   final int i;
//   SecondRoute({Key key, @required this.i}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Second Route $i"),
//       ),
//       body: Center(
//         child: RaisedButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           child: Text('Go back!'),
//         ),
//       ),
//     );
//   }
// }

class AutoComplete extends StatefulWidget {
  @override
  _AutoCompleteState createState() => new _AutoCompleteState();
}

class _AutoCompleteState extends State<AutoComplete> {
  GlobalKey<AutoCompleteTextFieldState<Champions>> key = new GlobalKey();

  AutoCompleteTextField searchTextField;

  TextEditingController controller = new TextEditingController();

  _AutoCompleteState();

  void _loadData() async {
    await ChampionsViewModel.loadChampions();
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgColor,
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text("Second Route"),
          backgroundColor: bgdarkColor,
        ),
        body: new Center(
            child: new Column(children: <Widget>[
          new Column(children: <Widget>[
            searchTextField = AutoCompleteTextField<Champions>(
                style: new TextStyle(color: lightColor, fontSize: 16.0),
                decoration: new InputDecoration(
                    suffixIcon: Container(
                      width: 85.0,
                      height: 60.0,
                    ),
                    contentPadding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
                    filled: true,
                    hintText: 'Search Champion Name',
                    hintStyle: TextStyle(color: lightColor)),
                itemSubmitted: (item) {
                  setState(() => searchTextField.textField.controller.text =
                      item.autocompleteterm);
                },
                clearOnSubmit: false,
                key: key,
                suggestions: ChampionsViewModel.champions,
                itemBuilder: (context, item) {
                  return Container(
                      color: bglightColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            item.autocompleteterm,
                            style: subtitleStyle,
                          ),
                          Padding(
                            padding: EdgeInsets.all(15.0),
                          ),
                        ],
                      ));
                },
                itemSorter: (a, b) {
                  return a.autocompleteterm.compareTo(b.autocompleteterm);
                },
                itemFilter: (item, query) {
                  return item.autocompleteterm
                      .toLowerCase()
                      .startsWith(query.toLowerCase());
                }),
          ]),
          RaisedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Go back!'),
          ),
        ])));
  }
}
