import 'package:flutter/material.dart';
import 'package:timeliner_flitter/logic/state.dart';

class EntryWidget extends StatelessWidget {
  final Entry entry;
  final double aspectRatio;
  final state = AppState();

  EntryWidget({
    super.key,
    required this.entry,
    required this.aspectRatio,
  });

  @override
  Widget build(BuildContext context) {
    var date_start_text =
        "${entry.start?.year}/${entry.start?.month}/${entry.start?.day}";
    var date_end_text = entry.end != null
        ? "${entry.end?.year}/${entry.end?.month}/${entry.end?.day}"
        : "Today";

    var imgWidget = Image.network(
      entry.image,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Icon(Icons.broken_image);
      },
    );

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          child: Flex(
            direction: Axis.vertical,
            mainAxisSize: MainAxisSize.max,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    height: (constraints.maxWidth / aspectRatio) * state.config.imageHeightPercentage,
                    width: constraints.maxWidth,
                    child: imgWidget,
                  );
                },
              ),
              Title(
                color: Colors.black,
                child: Text(entry.name, textScaler: TextScaler.linear(1.5)),
              ),
              Text("${date_start_text} ➡️ ${date_end_text}"),
              Text(entry.description),
            ],
          ),
        ),
      ),
    );
  }
}
