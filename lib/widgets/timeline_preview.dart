import 'dart:ffi';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:screenshot/screenshot.dart';
import 'package:timeliner_flitter/logic/state.dart';
import 'package:timeliner_flitter/widgets/entry.dart';
import 'package:timeliner_flitter/widgets/timeline_render.dart';

class TimelinePreviewWidget extends State<TimelinePreviewState> {
  AppState state = AppState();

  final screenshotListener = AppState().screenshotPath.subscribe((p) async {
    if (p == null) {
      return;
    }
    TimelineRenderWidget().saveAsImage(p);
  });


  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          //Slider(min: 0.0, max: 200.0, value: state.config.gap, onChanged: (v) {setState(() => state.config.gap = v);}),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (v) => {
                  setState(() {
                    state.config.gap = double.parse(v);
                  }),
                },
                //decoration: InputDecoration(label: Text("Gaps")),
                initialValue: state.config.gap.toString(),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (v) => {
                  setState(() {
                    state.config.size = double.parse(v);
                  }),
                },
                //decoration: InputDecoration(label: Text("Size")),
                initialValue: state.config.size.toString(),
              ),
              RadioGroup<Directions>(
                groupValue: state.config.exportDirection,
                onChanged: (v) => {setState(() {
                  if (v == null) {return;}
                  state.config.exportDirection = v;
                })}, 
                child: Column(
                  children: [
                    Row(children: [Radio(value: Directions.row), Text("Row")]),
                    Row(children: [Radio(value: Directions.column), Text("Column")])
                  ],
                ))
            ],
          ),
          SingleChildScrollView(
            physics: ScrollPhysics().parent,
            scrollDirection: state.config.exportDirection == Directions.row
                ? Axis.horizontal
                : Axis.vertical,

            child: StreamBuilder(stream: state.watcher, builder: (BuildContext context, AsyncSnapshot<FileSystemEvent?> snapshot) {
              return TimelineRenderWidget();
            })
          ),
        ],
      ),
    );
  }
}

class TimelinePreviewState extends StatefulWidget {
  const TimelinePreviewState({super.key});
  @override
  State<StatefulWidget> createState() => TimelinePreviewWidget();
}
