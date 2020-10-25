import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'champions.dart';

class ChampionsNames {
  String keyword;
  String autocompleteterm;

  ChampionsNames({this.keyword, this.autocompleteterm});

  factory ChampionsNames.fromJson(Map<String, dynamic> parsedJson) {
    return ChampionsNames(
        keyword: parsedJson['keyword'] as String,
        autocompleteterm: parsedJson['autocompleteTerm'] as String);
  }

  @override
  toString() => 'Keyword: $keyword, AutoCompleteTerm: $autocompleteterm';
}

class ChampionsNamesViewModel {
  static Map<String, List<ChampionsNames>> filteredSearch = {
    'ADC': List<ChampionsNames>(),
    'Support': List<ChampionsNames>(),
    'Middle': List<ChampionsNames>(),
    'Top': List<ChampionsNames>(),
    'Jungle': List<ChampionsNames>(),
  };
  static Future loadChampionsNames() async {
    try {
      filteredSearch.keys
          .forEach((k) => {filteredSearch[k] = new List<ChampionsNames>()});
      final path = await getApplicationDocumentsDirectory();
      final file = File('${path.path}/champions.json');
      String jsonString = await file.readAsString();
      Map parsedJson = json.decode(jsonString);
      var categoryJson = parsedJson['champions'] as List;
      var championsData = await ChampionsViewModel.loadChampions();

      for (int i = 0; i < categoryJson.length; i++) {
        var champion = new ChampionsNames.fromJson(categoryJson[i]);
        filteredSearch.keys.forEach((k) => {
              if (championsData[k].containsKey(champion.keyword))
                {filteredSearch[k].add(champion)}
            });
      }
      return filteredSearch;
    } catch (e) {
      print(e);
    }
  }
}
