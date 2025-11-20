import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_core.dart';
import 'package:timeliner_flutter/logic/state.dart';
import 'package:editable/editable.dart';

class _TimelineEditState extends State<TimelineEditWidget> {
  var state = AppState();
  var _editableKey = GlobalKey<EditableState>();

  List<List<dynamic>> data = [];

  void _initData() {
    data = const CsvToListConverter().convert(
      AppState().file?.readAsStringSync(encoding: utf8),
    );
    _editableKey = GlobalKey<EditableState>();
  }

  @override
  void initState() {
    _initData();
    super.initState();
  }

  void _createFile() {
    getSaveLocation().then((file) {
      if (file == null) {return;} 
      setState(() {
        state.createFile(file.path).then((f) {state = f;});
      });
      _saveState();
      _initData();
    });
  }

  void _saveState() {
    String csv = ListToCsvConverter().convert(data);
    state.file!.writeAsStringSync(csv);
  }

  void _handleDeleteRow() {
    if (data.length <= 1) {return;} //Prevent deleting headers
    data = data.sublist(0, data.length - 1).toList();
    _saveState();
    _initData();
  }

  void _handleAddRow() {
    data.add(
      List.generate(data[0].length, (e) {
        return "";
      }),
    );
    // _editableKey.currentState!.createRow();
    _saveState();
    _initData();
    setState(() {});
  }

  void _handleEditedRow() {
    var edited = (_editableKey.currentState!.editedRows);

    for (var r in edited) {
      var row = r as Map;
      var rowIndex = row['row'] + 1;
      if (rowIndex >= data.length) {
        data.add(
          List.generate(data[0].length, (e) {
            return "";
          }),
        );
      }
      var editedHeaders = row.keys.where((v) {
        return v != 'row';
      }).toList();
      for (var h in editedHeaders) {
        data[rowIndex][data[0].indexOf(h)] = row[h];
      }
    }

    setState(() {});
    _saveState();
  }

  Widget buildTable() {
    _initData();

    return IntrinsicHeight(
      child: Editable(
        onSubmitted: (_) => _handleEditedRow(),

        key: _editableKey,
        columns: data[0].map((e) {
          return {"title": e.toString(), 'widthFactor': 0.17, 'key': e.toString()};
        }).toList(),
        rows: data.sublist(1).map((r) {
          return Map
            .fromIterables(
              data[0].map((x) {return x.toString();}), 
              r.map((x) {return x.toString();})
            );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {


    if (state.file == null) {
      return IntrinsicHeight(
        child: Transform.scale(
          scale: 2.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.file_copy), 
              Text("No file loaded"),
              TextButton(onPressed: () {_createFile();}, child: Text("Create file"))
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          StreamBuilder(
            stream: state.watcher,
            builder: (context, snapshot) {
              return buildTable();
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  _handleAddRow();
                },
                child: Text("Add row"),
              ),
              TextButton(
                onPressed: () {
                  _handleDeleteRow();
                },
                child: Text("Delete row"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TimelineEditWidget extends StatefulWidget {
  final Function onChanged;

  const TimelineEditWidget({super.key, required this.onChanged});

  @override
  State<StatefulWidget> createState() => _TimelineEditState();
}
