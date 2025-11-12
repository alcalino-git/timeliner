


import 'package:flutter/material.dart';
import 'package:timeliner_flitter/logic/state.dart';

class EntryWidget extends StatelessWidget {
	final Entry entry;
	
	const EntryWidget({super.key, required this.entry});

	

	@override
	Widget build(BuildContext context) {

		return Column(
			children: [

				Card(
					clipBehavior: Clip.hardEdge,
					child: InkWell(
						child: Flex(direction: Axis.vertical, mainAxisSize: MainAxisSize.max, children: [
              Image.network(entry.image),
              Text(entry.description)
            ])
					)

				)
			]
		);
	}
}