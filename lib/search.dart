import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:champion_selector/champions.dart';
import 'style.dart';

class AutoComplete extends StatefulWidget {
  final String role;

  const AutoComplete({Key key, this.role}) : super(key: key);

  @override
  _AutoCompleteState createState() => new _AutoCompleteState();
}

class _AutoCompleteState extends State<AutoComplete> {
  var key = [new GlobalKey<AutoCompleteTextFieldState<Champions>>(), new GlobalKey<AutoCompleteTextFieldState<Champions>>(), new GlobalKey<AutoCompleteTextFieldState<Champions>>()];

  var searchTextField = List(3);
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
          style: hasChosen ? chosenStyle : subtitleStyle),
      color: hasChosen ? Colors.green : Colors.blueGrey,
      onPressed: hasChosen ? _findBestChampion : null,
    );
  }

  void _findBestChampion() {
    print("yes");
  }

  Widget _searchBar(i, role, {team='Enemy'}) {
    if ((role == 'Support' || role == 'ADC') && (widget.role != 'Support' && widget.role != 'ADC')) {
      return SizedBox.shrink();
    }
    return Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 80, width: 160,
                    child: Center(child: Text('$team $role:', style: titleStyle),)),
                  SizedBox(height: 80, width: 20),
                  Container(
                    height: 80,
                    width: 400,
                    child: searchTextField[i] = AutoCompleteTextField<Champions>(
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
                              searchTextField[i].textField.controller.text =
                                  item.autocompleteterm,
                            });
                      },
                      clearOnSubmit: false,
                      key: key[i],
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
                              'http://ddragon.leagueoflegends.com/cdn/10.16.1/img/champion/${searchTextField[i].textField.controller.text}.png',
                              width: 32,
                              height: 32,
                              fit: BoxFit.fill),
                        ))
                      : (new Icon(Icons.cancel)),
                ],
              ),
            );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Best matchup for ${widget.role}"),
        backgroundColor: bgdarkColor,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            _searchBar(0, widget.role),
            _searchBar(1, widget.role == 'ADC' ? 'Support' : 'ADC'),
            _searchBar(2, widget.role == 'Support' ? 'ADC' : 'Support', team: 'Ally'),
            _findChampionButton(),
            RaisedButton(
              color: Colors.red,
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Go back!', style: chosenStyle),
            ),
          ],
        ),
      ),
    );
  }
}
