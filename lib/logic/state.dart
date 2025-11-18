import "dart:async";
import "dart:convert";
import "dart:io";

import "package:csv/csv.dart";
import 'package:json_annotation/json_annotation.dart';
import "package:signals/signals.dart";

@JsonSerializable()
class Entry {
  String name = "";
  DateTime? start;
  DateTime? end;
  String description = "";
  String image = "";

  @override
  String toString() {
    return "{name: $name, start: $start, end: $end, description: $description, image: $image}";
  }

  static Entry fromCsvRow(List<String> headers, List<dynamic> row) {
    var entry = Entry();
    entry.name = row[headers.indexOf("name")];
    entry.start = DateTime.tryParse(row[headers.indexOf("start")]);
    entry.end = DateTime.tryParse(row[headers.indexOf("end")]);
    entry.description = row[headers.indexOf("description")];
    entry.image = row[headers.indexOf("image")];
    return entry;
  }
}

enum Directions { row, column }

class Config {
  Directions exportDirection = Directions.row;
  double gap = 6.0;
  double aspectRatio = 1 / 1;
  double size = 500;
  double imageHeightPercentage = 0.5;
}

class AppState {
  List<Entry> entries = [];
  final Signal<String?> screenshotPath = signal(null);
  Stream<FileSystemEvent>? watcher;
  StreamSubscription<FileSystemEvent>? listener;
  static final AppState _singleton = AppState._internal();
  File? file;
  Config config = Config();

  factory AppState() {
    return _singleton;
  }

  AppState._internal();

  Future<void> watchFileChanges() async {
    await listener?.cancel();
    if (file == null) {
      return;
    }

    watcher = file!.watch();
    listener = watcher?.listen((e) async {
      if (e.type == FileSystemEvent.modify) {
        loadFromCSV(file!.path);
      }
    });
  }


  Future<AppState> loadFromCSV(String filename) async {
    file = File(filename);
    if (file == null) {
      throw Exception("Got null file");
    }
    watchFileChanges();

    var contents = await file?.readAsString(encoding: utf8);
    var csvParsed = CsvToListConverter().convert(contents);
    List<String> headers = csvParsed[0].map((e) => e.toString()).toList();
    entries = csvParsed
        .sublist(1)
        .map((e) => Entry.fromCsvRow(headers, e))
        .toList();

    return this;
  }
}
