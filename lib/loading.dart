import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'style.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'user_preferences.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  int filesConcluded = 0;
  void _updateFiles() async {
    await updateFiles();
    SharedPreferencesClass.save("hasInstalledFilesForTheFirstTime", true);
    Navigator.pushNamed(context, '/home');
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateFiles());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SpinKitWave(
                      color: good,
                      size: 85.0,
                    ),
                    SizedBox(
                      height: 80,
                    ),
                    Text('5~10 min...', style: subtitleStyle),
                  ],
                ),
              ),
            ),
            Text('$filesConcluded/2...', style: titleStyle),
            RaisedButton(
              color: Colors.red,
              onPressed: () {
                Navigator.pop(context);
              },
              child:
                  Text('Cancel <might have consequences>', style: chosenStyle),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> _localFile(String filename) async {
    final path = await _localPath;
    return File('$path/$filename.json');
  }

  Future<File> writeData(data, filename) async {
    final file = await _localFile(filename);
    return file.writeAsString(json.encode(data));
  }

  Future<int> __updateFile(file) async {
    var parsedJson;
    await Process.run("python/python.exe", ["fetch_scripts/fetch_$file.py"])
        .then((process) async => {
              print(process.stdout),
              parsedJson = await json.decode(process.stdout),
            });
    await writeData(parsedJson, file);
    return 1;
  }

  Future updateFiles() async {
    var files = 0;
    files += await __updateFile('champions');
    setState(() => filesConcluded = files);
    files += await __updateFile('data');
    setState(() => filesConcluded = files);
  }
}
