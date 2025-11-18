

import 'package:flutter_test/flutter_test.dart';
import 'package:timeliner_flutter/logic/state.dart';
import 'package:timeliner_flutter/main.dart';

void main() {
    group("State testing", () {
        test("CSV parsing", () async {
            AppState state = await AppState().loadFromCSV("./software_figures.csv");
            print(state.entries);
            expect(state.entries.isEmpty,false);

        });
    });
}