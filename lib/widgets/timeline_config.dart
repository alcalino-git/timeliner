import 'package:flutter/material.dart';
import 'package:timeliner_flitter/logic/state.dart';
import 'package:flutter/src/services/text_formatter.dart' as filtering;

class _TimelineConfigWidgetState extends State<TimelineConfigWidget> {
  final state = AppState();

  @override
  Widget build(BuildContext context) {
    return Column(
      //crossAxisCount: 2,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          keyboardType: TextInputType.number,
          inputFormatters: [filtering.FilteringTextInputFormatter.digitsOnly],
          onChanged: (v) => {
            setState(() {
              state.config.gap = double.parse(v);
              this.widget.onChanged();
            }),
          },
          decoration: InputDecoration(label: Text("Gaps")),
          initialValue: state.config.gap.toString(),
        ),
        TextFormField(
          keyboardType: TextInputType.number,
          inputFormatters: [filtering.FilteringTextInputFormatter.digitsOnly],
          onChanged: (v) => {
            setState(() {
              state.config.size = double.parse(v);
              this.widget.onChanged();
            }),
          },
          decoration: InputDecoration(label: Text("Height (px)")),
          initialValue: state.config.size.toString(),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Aspect Ratio (Tall -> Wide)"),
            Slider(
              min: 0,
              max: 2,
              value: state.config.aspectRatio,
              onChanged: (v) => {
                setState(() {
                  state.config.aspectRatio = v;
                  this.widget.onChanged();
                }),
              },
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Image size"),
            Slider(
              min: 0,
              max: 1,
              value: state.config.imageHeightPercentage,
              onChanged: (v) => {
                setState(() {
                  state.config.imageHeightPercentage = v;
                  this.widget.onChanged();
                }),
              },
            ),
          ],
        ),
        RadioGroup<Directions>(
          groupValue: state.config.exportDirection,
          onChanged: (v) => {
            setState(() {
              if (v == null) {
                return;
              }
              state.config.exportDirection = v;
            }),
          },
          child: Column(
            children: [
              Row(
                children: [
                  Radio(value: Directions.row),
                  Text("Row"),
                ],
              ),
              Row(
                children: [
                  Radio(value: Directions.column),
                  Text("Column"),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TimelineConfigWidget extends StatefulWidget {
  final Function onChanged;

  const TimelineConfigWidget({super.key, required this.onChanged});

  @override
  State<StatefulWidget> createState() => _TimelineConfigWidgetState();
}
