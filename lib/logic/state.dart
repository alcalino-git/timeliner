import "dart:convert";
import "dart:io";

import "package:csv/csv.dart";
import 'package:json_annotation/json_annotation.dart';
import 'package:timeliner_flitter/main.dart';

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

class AppState  {
		List<Entry> entries = [];


		Future<AppState> loadFromCSV(String filename) async {
				var file = File(filename);
				var contents = await file.readAsString(encoding: utf8);
				var csvParsed = CsvToListConverter().convert(contents); 
				List<String> headers = csvParsed[0].map((e) => e.toString() ).toList();
				entries = csvParsed
						.sublist(1)
						.map((e) => Entry.fromCsvRow(headers, e))
						.toList();
				return this;
		}
}

