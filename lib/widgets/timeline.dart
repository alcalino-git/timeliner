


import 'package:flutter/material.dart';
import 'package:timeliner_flitter/logic/state.dart';
import 'package:timeliner_flitter/widgets/entry.dart';

class TimelineWidget extends StatelessWidget {
	final AppState state;
  final double widgetAspectRatio;
	const TimelineWidget({super.key, required this.state, this.widgetAspectRatio = 1/1});
	


	@override
	Widget build(BuildContext context) {
		return Expanded(child: 
			LayoutBuilder(
				builder: (context, constraints) {
					final w = constraints.maxWidth;
					final h = constraints.maxHeight;
					final itemW = w * 0.33;
					final itemH = h * 0.20;

					return  GridView.count(
						crossAxisCount: (w / itemW).toInt(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: widgetAspectRatio,
						children: state.entries.map((e) => EntryWidget(entry: e, imageAspectRatio: widgetAspectRatio,)).toList(),
					);
				},
			)
		);
	}
	
}