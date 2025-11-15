import 'dart:io';

import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:timeliner_flitter/logic/state.dart';
import 'package:timeliner_flitter/widgets/entry.dart';

class TimelineRenderState extends State<TimelineRenderWidget> {
  final AppState state = AppState();

  Widget buildView() {
    var contents = state.entries
        .map(
          (e) =>
              EntryWidget(entry: e, aspectRatio: state.config.aspectRatio),
        )
        .toList();

    Widget view;

    var entryWidth = state.config.size * state.config.aspectRatio;
    var entryHeight = state.config.size;

    switch (state.config.exportDirection) {
      case Directions.column:
        view = SizedBox(
          width: entryWidth,
          height: (entryHeight + state.config.gap) * state.entries.length,
          child: Column(spacing: state.config.gap, children: contents),
        );

      case Directions.row:
        view = SizedBox(
          height: entryHeight,
          width: (entryWidth + state.config.gap) * state.entries.length,
          child: Row(spacing: state.config.gap, children: contents),
        );
    }

    return view;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: state.watcher,
      builder:
          (BuildContext context, AsyncSnapshot<FileSystemEvent?> snapshot) {
            return buildView();
          },
    );
  }
}

class TimelineRenderWidget extends StatefulWidget {
  const TimelineRenderWidget({super.key});

  @override
  State<StatefulWidget> createState() => TimelineRenderState();
}
