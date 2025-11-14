import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:timeliner_flitter/logic/state.dart';
import 'package:timeliner_flitter/widgets/entry.dart';

class TimelineRenderWidget extends StatelessWidget {
  final AppState state = AppState();

  TimelineRenderWidget({super.key});
  ScreenshotController screenshotController = ScreenshotController();

  Future<void> saveAsImage(String path) async {
    screenshotController.captureAndSave(path);
  }

  @override
  Widget build(BuildContext context) {
    var contents = state.entries.peek()
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
          height: (state.config.size+state.config.gap)*state.entries.peek().length,
          child: Column(spacing: state.config.gap, children: contents),
        );

      case Directions.row:
        view =  SizedBox(
          height: state.config.size,
          width: (state.config.size+state.config.gap)*state.entries.peek().length,
          child: Row(spacing: state.config.gap, children: contents),
        );

    }

    return Screenshot(controller: screenshotController, child: view);

  }
}
