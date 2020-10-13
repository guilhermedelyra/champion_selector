import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:champion_selector/champions_names.dart';
import 'package:champion_selector/champions.dart';
import 'style.dart';

class AutoComplete extends StatefulWidget {
  final String role;

  const AutoComplete({Key key, this.role}) : super(key: key);

  @override
  _AutoCompleteState createState() => new _AutoCompleteState();
}

class _AutoCompleteState extends State<AutoComplete> {
  var key = [
    new GlobalKey<AutoCompleteTextFieldState<ChampionsNames>>(),
    new GlobalKey<AutoCompleteTextFieldState<ChampionsNames>>(),
    new GlobalKey<AutoCompleteTextFieldState<ChampionsNames>>()
  ];

  static const MATCHUP = 0;
  static const ADCSUPPORT = 1;
  static const SYNERGY = 2;

  var searchTextField = List(3);
  TextEditingController controller = new TextEditingController();
  var chosenChampion = ['', '', ''];
  var howManyChosen = 1;
  var chosenAny = false;
  Map championsData;

  var possibleChampions = new Map<String, double>();
  _AutoCompleteState();

  void _loadData() async {
    await ChampionsNamesViewModel.loadChampionsNames();
    championsData = await ChampionsViewModel.loadChampions();

    championsData[widget.role].keys.forEach((k) => {
          possibleChampions[k] = championsData[widget.role][k]['winrate'],
        });
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  Widget _findChampionButton() {
    return new RaisedButton(
      child: new Text(
          chosenAny ? "Find best champion" : "Choose a champion first!",
          style: chosenAny ? chosenStyle : subtitleStyle),
      color: chosenAny ? Colors.green : Colors.blueGrey,
      onPressed: chosenAny ? _findBestChampion : null,
    );
  }

  void _findBestSynergy() {
    championsData[widget.role][chosenChampion[SYNERGY]]['synergy']
        .forEach((champ, winrate) => {
              possibleChampions[champ] += winrate,
            });
  }

  void _findBestADCSupport() {
    //same as matchup
    championsData[widget.role][chosenChampion[ADCSUPPORT]]['adcsupport']
        .forEach((champ, winrate) => {
              possibleChampions[champ] += 1 - winrate,
            });
  }

  void _findBestMatchup() {
    championsData[widget.role][chosenChampion[MATCHUP]]['matchups']
        .forEach((champ, winrate) => {
              possibleChampions[champ] += 1 - winrate,
            });
  }

  void _findBestChampion() {
    _findBestMatchup();
    _findBestADCSupport();
    _findBestSynergy();

    for (var keys in possibleChampions.keys) {
      possibleChampions[keys] /= howManyChosen;
    }
  }

  Widget _searchBar(i, role, {team = 'Enemy'}) {
    if ((role == 'Support' || role == 'ADC') &&
        (widget.role != 'Support' && widget.role != 'ADC')) {
      return SizedBox.shrink();
    }
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              height: 80,
              width: 160,
              child: Center(
                child: Text('$team $role:', style: titleStyle),
              )),
          SizedBox(height: 80, width: 20),
          Container(
            height: 80,
            width: 400,
            child: searchTextField[i] = AutoCompleteTextField<ChampionsNames>(
              style: TextStyle(color: lightColor, fontSize: 16.0),
              decoration: InputDecoration(
                suffixIcon: new Icon(Icons.search),
                contentPadding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
                filled: true,
                hintText: 'Search Champion Name',
                hintStyle: TextStyle(color: lightColor),
              ),
              itemSubmitted: (item) {
                setState(() => {
                      chosenAny = true,
                      howManyChosen += 1,
                      chosenChampion[i] = item.autocompleteterm,
                      searchTextField[i].textField.controller.text =
                          item.autocompleteterm,
                    });
              },
              clearOnSubmit: false,
              key: key[i],
              suggestions: ChampionsNamesViewModel.champions,
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
          chosenChampion[i] != ''
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
            _searchBar(MATCHUP, widget.role), // matchup
            _searchBar(ADCSUPPORT,
                widget.role == 'ADC' ? 'Support' : 'ADC'), // adcsupport
            _searchBar(SYNERGY, widget.role == 'Support' ? 'ADC' : 'Support',
                team: 'Ally'), // synergy
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
