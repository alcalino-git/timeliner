import 'dart:ffi';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:screenshot/screenshot.dart';
import 'package:timeliner_flitter/logic/state.dart';
import 'package:timeliner_flitter/widgets/entry.dart';
import 'package:timeliner_flitter/widgets/timeline_config.dart';
import 'package:timeliner_flitter/widgets/timeline_render.dart';

class _TimelinePreviewWidgetState extends State<TimelinePreviewWidget> {
  AppState state = AppState();
  final timelineKey = GlobalKey<TimelineRenderState>();
  final _screenshotController = ScreenshotController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    state.screenshotPath.subscribe((p) async {
      if (p == null) return;
      var data = await _screenshotController.captureFromLongWidget(
        TimelineRenderWidget(key: timelineKey),
      );
      var file = File(p);
      file.writeAsBytes(data);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
          //Slider(min: 0.0, max: 200.0, value: state.config.gap, onChanged: (v) {setState(() => state.config.gap = v);}),
          TimelineConfigWidget(
            onChanged: () {
              setState(() {});
            },
          ),
          Flexible(
            child: Scrollbar(
              controller: _scrollController,
              interactive: true,
              thumbVisibility: true,
              trackVisibility: true,
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: state.config.exportDirection == Directions.row
                    ? Axis.horizontal
                    : Axis.vertical,

                child: Screenshot(
                  controller: _screenshotController,
                  child: TimelineRenderWidget(),
                ),
              ),
            ),
          ),
        ],
    );
  }
}

class TimelinePreviewWidget extends StatefulWidget {
  final timelineKey = GlobalKey<TimelineRenderState>();
  TimelinePreviewWidget({super.key});

  @override
  State<StatefulWidget> createState() => _TimelinePreviewWidgetState();
}
