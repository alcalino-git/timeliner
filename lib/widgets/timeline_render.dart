import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:timeliner_flitter/logic/state.dart';
import 'package:timeliner_flitter/widgets/entry.dart';


class TimelineRenderState extends State<TimelineRenderWidget> {
  final AppState state = AppState();
  final ScreenshotController screenshotController = ScreenshotController();

  // Future<void> saveAsImage(String path) async {
  //   await WidgetsBinding.instance.endOfFrame;
  //   await screenshotController.captureAndSave(path);
  // }

  @override
  Widget build(BuildContext context) {
    var contents = state.entries
        .map(
          (e) =>
              EntryWidget(entry: e, imageAspectRatio: state.config.aspectRatio),
        )
        .toList();

    Widget view;

    switch (state.config.exportDirection) {
      case Directions.column: 
        view = SizedBox(
          width: state.config.size,
          height: (state.config.size+state.config.gap)*state.entries.length,
          child: Column(spacing: state.config.gap, children: contents),
        );

      case Directions.row:
        view =  SizedBox(
          height: state.config.size,
          width: (state.config.size+state.config.gap)*state.entries.length,
          child: Row(spacing: state.config.gap, children: contents),
        );

    }

    return Screenshot(controller: screenshotController, child: view);

  }
  
}

class TimelineRenderWidget extends StatefulWidget {
  const TimelineRenderWidget({super.key});
  
  @override
  State<StatefulWidget> createState() => TimelineRenderState();
}
