import 'dart:convert';

import 'package:flutter/services.dart';

class ChampionsViewModel {
  static Future loadChampions() async {
    try {
      String jsonString = await rootBundle.loadString('assets/data.json');
      Map parsedJson = json.decode(jsonString);
      return parsedJson;
    } catch (e) {
      print(e);
    }
  }
}
