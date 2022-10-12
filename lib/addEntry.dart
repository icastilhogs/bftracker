import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

final String entriesTable = 'entries';

class EntryFields {
  static const String id = '_id';
  static const String name = 'name';
  static const String value = 'value';
  static const String desc = 'desc';
  static const String timestamp = 'timestamp';
}

enum Trackers {
  // body measurements
  weight('Weight'),
  waist('Waist'),
  buttocks('Buttocks'),
  sk1('Skinfold'),

  // calorie intake
  calories('Calories'), // only one daily input that can be edited

  // macros
  protein('Protein'),
  carbs('Carbohidrate'),
  fat('Fat'),

  //activities
  cardio('Cardio activities'),
  rT('Resistance training'),

  //anotations
  notes('Notes');

  final String inputDecoration;

  const Trackers(this.inputDecoration);
}

class Tracker {
  Tracker({
    required this.type,
    this.timestamp,
    this.value,
    this.controller,
  });

  final Trackers type;
  final DateTime? timestamp;
  double? value;
  final TextEditingController? controller;
}

class AddEntry extends HookWidget {
  const AddEntry({required this.title, Key? key}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    final weight = useState(0.00);
    final List<Tracker> inputs = [];

    void _generateInputs() {
      for (int i = 0; i < Trackers.values.length; i++) {
        inputs.add(Tracker(
            type: Trackers.values[i], controller: useTextEditingController()));
      }
    }

    void calculateBF(String input, controller) {
      weight.value = double.parse(input);
      inputs.firstWhere((e) => e.type == Trackers.weight).value = weight.value;
      print(controller.text);
    }

    _generateInputs();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: inputs
                    .map((e) => TextField(
                          maxLength: 6,
                          controller: e.controller,
                          keyboardType: TextInputType.number,
                          inputFormatters: [],
                          decoration: InputDecoration(
                            labelText: e.type.inputDecoration,
                            hintText: 'your weight in kg',
                            //helperText: 'your weight in kg',
                            suffixText: 'kg',
                            alignLabelWithHint: true,
                          ),
                          onChanged: (value) =>
                              calculateBF(value, e.controller),

                          //onEditingComplete: () => weight = e.controller.text,
                        ))
                    .toList(),
              ),
              Text(weight.value.toString())
            ],
          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
