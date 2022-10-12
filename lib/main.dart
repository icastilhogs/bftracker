import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'addEntry.dart';
import 'hive_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveConfig.start();
  runApp(const BFTracker());
}

class BFTracker extends StatelessWidget {
  const BFTracker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BF tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      onGenerateRoute: (settings) {
        final args = settings.arguments as String?;
        return MaterialPageRoute(builder: (context) {
          switch (settings.name) {
            case '/':
              return HomePage();
            case 'addEntry':
              return const AddEntry(title: 'Add new entry');
            default:
              return HomePage();
          }
        });
      },
    );
  }
}

class HomePage extends HookWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello, user'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, 'addEntry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(),
      ),
    );
  }
}
