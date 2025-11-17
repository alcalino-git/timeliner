import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:timeliner_flitter/logic/state.dart';
import 'package:editable/editable.dart';

class _TimelineEditState extends State<TimelineEditWidget> {
  final state = AppState();
  final _editableKey = GlobalKey<EditableState>(); 
  List<List<dynamic>> data = const CsvToListConverter().convert(
    AppState().file?.readAsStringSync(encoding: utf8),
  );


  void _saveState() {
    String csv = ListToCsvConverter().convert(data);
    state.file!.writeAsStringSync(csv); 
  }


  void _handleEditedRow() {
        var edited = (_editableKey.currentState!.editedRows);
        setState(() {
          for (var (row as Map) in edited) {
            var rowIndex = row['row']+1;
            var editedHeaders = row.keys.where((v) {return v != 'row';}).toList();
            for (var h in editedHeaders) {
              data[rowIndex][data[0].indexOf(h)] = row[h];
            }
          }

          _saveState();
        });
        
  }

  Widget buildView() {

    
    return Editable(
      onSubmitted: (_) => _handleEditedRow(),
      key: _editableKey,
      columns: data[0].map((e) {
        return {"title":e, 'widthFactor': 0.2, 'key':e};
      }).toList(),
      rows: data.sublist(1).map((r) {
        return Map.fromIterables(data[0], r);
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
