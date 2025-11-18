import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:timeliner_flutter/logic/state.dart';
import 'package:editable/editable.dart';

class _TimelineEditState extends State<TimelineEditWidget> {
  final state = AppState();
  final _editableKey = GlobalKey<EditableState>();

  List<List<dynamic>> data = const CsvToListConverter().convert(
    AppState().file?.readAsStringSync(encoding: utf8),
  );

  void _initData() {
    data = const CsvToListConverter().convert(
      AppState().file?.readAsStringSync(encoding: utf8),
    );
  }

  @override
  void initState() {
    _initData();
    super.initState();
  }

  void _saveState() {
    String csv = ListToCsvConverter().convert(data);
    state.file!.writeAsStringSync(csv);
  }

  void _handleDeleteRow() {
    setState(() {
      data = data.sublist(0, data.length - 1).toList();
    });

    _saveState();

    _editableKey.currentState?.rows = _editableKey.currentState!.rows!.sublist(
      0,
      _editableKey.currentState!.rows!.length - 1,
    );
    setState(() {});
  }

  void _handleAddRow() {
    data.add(
      List.generate(data[0].length, (e) {
        return "";
      }),
    );
    _editableKey.currentState!.createRow();
    _saveState();
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

  Widget buildView() {
    _initData();

    return IntrinsicHeight(
      child: Editable(
        onSubmitted: (_) => _handleEditedRow(),

        key: _editableKey,
        columns: data[0].map((e) {
          return {"title": e, 'widthFactor': 0.17, 'key': e};
        }).toList(),
        rows: data.sublist(1).map((r) {
          return Map.fromIterables(data[0], r);
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
            children: [Icon(Icons.file_copy), Text("No file loaded")],
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
              return buildView();
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
