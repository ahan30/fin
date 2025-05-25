import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final String icon;
  final Color color;
  final double? budgetLimit;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    this.budgetLimit,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      icon: map['icon'] ?? '📦',
      color: Color(map['color'] ?? Colors.grey.value),
      budgetLimit: map['budgetLimit']?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'color': color.value,
      'budgetLimit': budgetLimit,
    };
  }
}
