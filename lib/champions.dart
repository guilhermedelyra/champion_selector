import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ChampionsViewModel {
  static Future loadChampions() async {
    try {
      final path = await getApplicationDocumentsDirectory();
      final file = File('${path.path}/data.json');
      String jsonString = await file.readAsString();
      Map parsedJson = json.decode(jsonString);
      return parsedJson;
    } catch (e) {
      print(e);
    }
  }
}
