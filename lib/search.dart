import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:champion_selector/champions.dart';
import 'style.dart';

class AutoComplete extends StatefulWidget {
  final int i;

  const AutoComplete({Key key, this.i}) : super(key: key);

  @override
  _AutoCompleteState createState() => new _AutoCompleteState();
}

class _AutoCompleteState extends State<AutoComplete> {
  GlobalKey<AutoCompleteTextFieldState<Champions>> key = new GlobalKey();

  AutoCompleteTextField searchTextField;
  // bool showWhichErrorText = false;
  TextEditingController controller = new TextEditingController();
  bool hasChosen;
  _AutoCompleteState();

  void _loadData() async {
    await ChampionsViewModel.loadChampions();
  }

  @override
  void initState() {
    _loadData();
    hasChosen = false;
    super.initState();
  }

  Widget _findChampionButton() {
    return new RaisedButton(
      child: new Text(
          hasChosen ? "Find best champion" : "Choose a champion first!",
          style: subtitleStyle),
      color: hasChosen ? Colors.green : Colors.blueGrey,
      onPressed: hasChosen ? _findBestChampion : null,
    );
  }

  void _findBestChampion() {
    print("yes");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Second Route ${widget.i}"),
        backgroundColor: bgdarkColor,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Enemy Mid:', style: titleStyle),
                  SizedBox(height: 80, width: 20),
                  Container(
                    height: 80,
                    width: 400,
                    child: searchTextField = AutoCompleteTextField<Champions>(
                      style: TextStyle(color: lightColor, fontSize: 16.0),
                      decoration: InputDecoration(
                        suffixIcon: new Icon(Icons.search),
                        contentPadding:
                            EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
                        filled: true,
                        hintText: 'Search Champion Name',
                        hintStyle: TextStyle(color: lightColor),
                      ),
                      itemSubmitted: (item) {
                        setState(() => {
                              hasChosen = true,
                              print(hasChosen),
                              searchTextField.textField.controller.text =
                                  item.autocompleteterm,
                            });
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
                              // Icon()
                              Padding(
                                padding: EdgeInsets.all(15.0),
                              ),
                            ],
                          ),
                        );
                      },
                      itemSorter: (a, b) {
                        return a.autocompleteterm.compareTo(b.autocompleteterm);
                      },
                      itemFilter: (item, query) {
                        return item.autocompleteterm
                            .toLowerCase()
                            .startsWith(query.toLowerCase());
                      },
                    ),
                  ),
                  hasChosen
                      ? (new ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0),
                          ),
                          child: Image.network(
                              'http://ddragon.leagueoflegends.com/cdn/10.16.1/img/champion/${searchTextField.textField.controller.text}.png',
                              width: 32,
                              height: 32,
                              fit: BoxFit.fill),
                        ))
                      : (new Icon(Icons.cancel)),
                ],
              ),
            ),
            _findChampionButton(),
            RaisedButton(
              color: Colors.red,
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Go back!', style: subtitleStyle),
            ),
          ],
        ),
      ),
    );
  }
}
