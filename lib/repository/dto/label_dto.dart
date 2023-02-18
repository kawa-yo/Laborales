import 'package:flutter/material.dart';

class LabelDTO {
  static const columnName = "name";
  static const columnColorR = "color_r";
  static const columnColorG = "color_g";
  static const columnColorB = "color_b";
  static const columnColorA = "color_a";
  static const List<String> columns = [
    columnName,
    columnColorR,
    columnColorG,
    columnColorB,
    columnColorA,
  ];

  final String name;
  final Color color;

  const LabelDTO({required this.name, required this.color});

  factory LabelDTO.fromMap(Map<String, dynamic> map) {
    return LabelDTO(
      name: map[columnName],
      color: Color.fromARGB(
        map[columnColorA],
        map[columnColorR],
        map[columnColorG],
        map[columnColorB],
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      columnName: name,
      columnColorR: color.red,
      columnColorG: color.green,
      columnColorB: color.blue,
      columnColorA: color.alpha,
    };
  }
}
