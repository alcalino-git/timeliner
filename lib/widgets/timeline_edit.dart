import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:timeliner_flitter/logic/state.dart';

class _TimelineEditState extends State<TimelineEditWidget> {
  final state = AppState();

  Widget buildView() {
    
    List<List<dynamic>> data = const CsvToListConverter().convert(
      state.file?.readAsStringSync(encoding: utf8),
    );
    var headers = data[0];

    return DataTable(
          columns: headers.map((h) {
            return DataColumn(label: Text(h));
          }).toList(),
          rows: data.sublist(1).map((r) {
            return DataRow(
              cells: r.map((v) {
                return DataCell(Text(v));
              }).toList(),
            );
          }).toList(),
        );
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      stream: state.watcher,
      builder: (context, snapshot) {
        return buildView();
      },
    );
  }
}

class TimelineEditWidget extends StatefulWidget {
  final Function onChanged;

  const TimelineEditWidget({super.key, required this.onChanged});

  @override
  State<StatefulWidget> createState() => _TimelineEditState();
}
