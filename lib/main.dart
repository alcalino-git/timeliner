import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:timeliner_flitter/logic/state.dart';
import 'package:timeliner_flitter/widgets/entry.dart';
import 'package:timeliner_flitter/widgets/timeline.dart';

void main() {
	runApp(const MainApp());
}

class AppStateWidget extends State<MainApp> {
	List<Entry> entries = [];
	AppState state = AppState();
	int counter = 0;
	
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			home: Scaffold(
        appBar: AppBar(
          title: Text("Timeliner"),
          shadowColor: Theme.of(context).colorScheme.shadow,
          actions: [
            TextButton(
              onPressed: () async {
                this.state = await state.loadFromCSV("./software_figures.csv");
                setState(() {this.state = state;});
              }, 
              child: Text("Update")
            )
          ],
        ),
				body: Center(
					child: Column(
						mainAxisAlignment: MainAxisAlignment.center,
						children: [
							TimelineWidget(state: state)
						]
					),
				),
			),
		);
	}
}

class MainApp extends StatefulWidget {
	final String name = "idk";


	const MainApp({super.key});

	@override
	State<StatefulWidget> createState() => AppStateWidget();



}
