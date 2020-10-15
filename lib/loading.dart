import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:process_run/shell.dart';
import 'style.dart';
import 'package:process_run/cmd_run.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

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

Future __updateFile(file) async {
  var parsedJson;
  await Process.run("python/python.exe", ["fetch_scripts/fetch_$file.py"])
      .then((process) async => {
            print(process.stdout),
            parsedJson = await json.decode(process.stdout),
          });
  await writeData(parsedJson, file);
}

Future updateFiles() async {
  // await __updateFile('champions');
  await __updateFile('data');

  // await writeCounter(5);
  // var shell = Shell();
  // final runInShell = Platform.isWindows;

  // await runCmd(cmd, verbose: true);
  // shell = shell.pushd('flutter_assets');
  // shell = shell.pushd('python');
  // await shell.run('''
  // cmd.exe ${shellArgument('/C python.exe fetch_data.py')}
  // ''');
}

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void _updateFiles() async {
    await new Future.delayed(const Duration(seconds: 5), () {});
    // await updateFiles();
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _updateFiles();
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
}
