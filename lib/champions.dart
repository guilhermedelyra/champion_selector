import 'dart:convert';

import 'package:flutter/services.dart';

class Champions {
  String keyword;
  // int id;
  String autocompleteterm;

  Champions({this.keyword, this.autocompleteterm});

  factory Champions.fromJson(Map<String, dynamic> parsedJson) {
    return Champions(
        keyword: parsedJson['keyword'] as String,
        // id: parsedJson['id'],
        autocompleteterm: parsedJson['autocompleteTerm'] as String);
  }
}

class ChampionsViewModel {
  static List<Champions> champions;

  static Future loadChampions() async {
    try {
      champions = new List<Champions>();
      String jsonString = await rootBundle.loadString('assets/champions.json');
      Map parsedJson = json.decode(jsonString);
      var categoryJson = parsedJson['champions'] as List;
      for (int i = 0; i < categoryJson.length; i++) {
        champions.add(new Champions.fromJson(categoryJson[i]));
      }
      return champions;
    } catch (e) {
      print(e);
    }
  }
}
