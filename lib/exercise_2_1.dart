import 'package:flutter/material.dart';

import 'main.dart' show StudentDetailsSection, TitleSection;

/// Run with: flutter run -t lib/exercise_2_1.dart
/// Exercise 2.1 isolates the decomposed title row before adaptive layouts.
void main() => runApp(const Exercise21App());

class Exercise21App extends StatelessWidget {
  const Exercise21App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'CSS3344 Lab 02 - Exercise 2.1',
    theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
    home: Scaffold(
      appBar: AppBar(
        title: const Text('CSS3344 Lab 02 - Exercise 2.1'),
        titleTextStyle: const TextStyle(fontSize: 16, color: Colors.black87),
        centerTitle: true,
        backgroundColor: const Color(0xFFE0E0FF),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          StudentDetailsSection(),
          SizedBox(height: 16),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: Text(
                    'Location Details',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                TitleSection(
                  name: 'Oeschinen Lake',
                  location: 'Kandersteg, Switzerland',
                  starCount: 41,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
