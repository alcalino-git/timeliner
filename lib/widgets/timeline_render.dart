import 'package:flutter/material.dart';
import 'package:timeliner_flitter/logic/state.dart';
import 'package:timeliner_flitter/widgets/entry.dart';

class TimelineRenderWidget extends StatelessWidget {
  final AppState state = AppState();

  TimelineRenderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var contents = state.entries
        .map(
          (e) =>
              EntryWidget(entry: e, imageAspectRatio: state.config.aspectRatio),
        )
        .toList();


    switch (state.config.exportDirection) {
      case Directions.column: 
        return SizedBox(
          width: state.config.size,
          height: (state.config.size+state.config.gap)*state.entries.length,
          child: Column(spacing: state.config.gap, children: contents),
        );

      case Directions.row:
        return SizedBox(
          height: state.config.size,
          width: (state.config.size+state.config.gap)*state.entries.length,
          child: Row(spacing: state.config.gap, children: contents),
        );

    }

  }
}
