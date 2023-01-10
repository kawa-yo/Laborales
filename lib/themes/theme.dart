import 'package:flutter/material.dart';

const rainbow = [
  Colors.red,
  Colors.pink,
  Colors.purple,
  Colors.deepPurple,
  Colors.indigo,
  Colors.blue,
  Colors.lightBlue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.lightGreen,
  Colors.lime,
  Colors.yellow,
  Colors.amber,
  Colors.orange,
  Colors.deepOrange,
  Colors.brown,
  Colors.grey,
  Colors.blueGrey,
];

const tenColors = [
  Colors.red,
  Colors.purple,
  Colors.indigo,
  Colors.lightBlue,
  Colors.teal,
  Colors.lightGreen,
  Colors.yellow,
  Colors.orange,
  Colors.brown,
  Colors.blueGrey,
];

const primaryColor = Colors.blueGrey;
const secondaryColor = Color(0xFF90A4AE); // Colors.blueGrey[300]!
const thirdColor = Color.fromARGB(255, 186, 217, 232);
const lastColor = Color.fromARGB(255, 248, 250, 252);
final backgroundColor = Colors.grey[50]!;

final lightTheme = ThemeData(
  primarySwatch: primaryColor,
  textTheme: const TextTheme(),
);
