import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:screenshot/screenshot.dart';
import 'package:timeliner_flitter/logic/state.dart';
import 'package:timeliner_flitter/widgets/entry.dart';
import 'package:timeliner_flitter/widgets/timeline_render.dart';


class TimelinePreviewWidget extends State<TimelinePreviewState> {
  AppState state = AppState();

  final screenshotListener = AppState().screenshotPath.subscribe((p) async {
    var bytes =await ScreenshotController().captureFromLongWidget(TimelineRenderWidget());
    var file = File(p as String);
    await file.writeAsBytes(bytes);
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Column(children: [
      Slider(min: 0.0, max: 200.0, value: state.config.gap, onChanged: (v) {setState(() => state.config.gap = v);}),
      SingleChildScrollView(
        physics: ScrollPhysics().parent,
        scrollDirection: state.config.exportDirection == Directions.row ? Axis.horizontal : Axis.vertical,
        
        child: TimelineRenderWidget()
      )
    ]));
  }
}



class TimelinePreviewState extends StatefulWidget {

  const TimelinePreviewState({super.key});
    
  @override
  State<StatefulWidget> createState() => TimelinePreviewWidget();
}
