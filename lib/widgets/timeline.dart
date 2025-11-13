import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:screenshot/screenshot.dart';
import 'package:timeliner_flitter/logic/state.dart';
import 'package:timeliner_flitter/widgets/entry.dart';

class TimelineWidget extends StatelessWidget {
  final double widgetAspectRatio;

  TimelineWidget({super.key, this.widgetAspectRatio = 1 / 1}) {
    state.screenshotPath.subscribe((p) async {
      var data = await screenshotController.captureFromLongWidget(
        Column(
          children: state.entries
              .map(
                (e) =>
                    EntryWidget(entry: e, imageAspectRatio: widgetAspectRatio),
              )
              .toList(),
        ),
      );
			var file = File(p as String);
			await file.writeAsBytes(data);
    });
  }

  final AppState state = AppState();
  final ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final itemW = w * 0.33;

          return GridView.count(
            crossAxisCount: (w / itemW).toInt(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: widgetAspectRatio,
            children: state.entries
                .map(
                  (e) => EntryWidget(
                    entry: e,
                    imageAspectRatio: widgetAspectRatio,
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}
