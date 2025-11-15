import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:timeliner_flitter/logic/state.dart';
import 'package:timeliner_flitter/widgets/entry.dart';
import 'package:timeliner_flitter/widgets/timeline_preview.dart';

void main() {
  runApp(const MaterialApp(home: MainApp()));
}

class AppStateWidget extends State<MainApp> {
  List<Entry> entries = [];
  AppState state = AppState();
  int counter = 0;

  final XTypeGroup typeGroup = XTypeGroup(label: "csv", extensions: [".csv"]);

  AlertDialog dialog = AlertDialog(
    title: Text("Warning"),
    content: Text("""
				No data could be extracted from the selected file.
				Please make sure it is in the correct format.
				The expected headers are: [name, start, end, description, image]
				"""),
  );

  Future<void> handleSelectFile(BuildContext context) async {
    final XFile? file = await openFile(acceptedTypeGroups: [typeGroup]);
    if (file == null) {
      return;
    }
    state = await state.loadFromCSV(file.path);
    setState(() {
      state = state;
    });
    if (state.entries.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        },
      );
    }
  }

  Future<void> handleSaveFile(BuildContext context) async {
	var file = await getSaveLocation(acceptedTypeGroups: [XTypeGroup(mimeTypes: ["image"])]);
	if (file == null) {
	  return;
	}
	state.screenshotPath.set(file.path);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Timeliner"),
          shadowColor: Theme.of(context).colorScheme.shadow,
          actions: [
            TextButton(
              onPressed: () => handleSelectFile(context),
              child: Text("Open"),
            ),
            TextButton(onPressed: () => handleSaveFile(context), child: Text("Export")),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [TimelinePreviewState()],
          ),
        ),
      ),
    );
  }
}

class MainApp extends StatefulWidget {

  const MainApp({super.key});

  @override
  State<StatefulWidget> createState() => AppStateWidget();
}
