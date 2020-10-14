import 'dart:convert';

import 'package:flutter/services.dart';

class ChampionsNames {
  String keyword;
  // int id;
  String autocompleteterm;

  ChampionsNames({this.keyword, this.autocompleteterm});

  factory ChampionsNames.fromJson(Map<String, dynamic> parsedJson) {
    return ChampionsNames(
        keyword: parsedJson['keyword'] as String,
        // id: parsedJson['id'],
        autocompleteterm: parsedJson['autocompleteTerm'] as String);
  }
}

class ChampionsNamesViewModel {
  static List<ChampionsNames> champions;

  static Future loadChampionsNames() async {
    try {
      champions = new List<ChampionsNames>();
      String jsonString = await rootBundle.loadString('assets/champions.json');
      Map parsedJson = json.decode(jsonString);
      var categoryJson = parsedJson['champions'] as List;
      for (int i = 0; i < categoryJson.length; i++) {
        champions.add(new ChampionsNames.fromJson(categoryJson[i]));
      }
      return champions;
    } catch (e) {
      print(e);
    }
  }
}
