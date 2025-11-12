


import 'package:flutter/material.dart';
import 'package:timeliner_flitter/logic/state.dart';

class EntryWidget extends StatelessWidget {
	final Entry entry;
  final double imageAspectRatio;
	
	const EntryWidget({super.key, required this.entry, required this.imageAspectRatio });

	

	@override
	Widget build(BuildContext context) {

		return 
				AspectRatio(
          aspectRatio: imageAspectRatio,
          child: Card(
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              child: Flex(direction: Axis.vertical, mainAxisSize: MainAxisSize.max, children: [
                LayoutBuilder(builder: (context, constraints) {
                  return SizedBox(
                    height: (constraints.maxWidth/imageAspectRatio)/2, 
                    width: constraints.maxWidth, 
                    child: Image.network(entry.image, fit: BoxFit.cover),
                  );
                }),
                Text(entry.description)
              ])
            )

          )
        );
	}
}