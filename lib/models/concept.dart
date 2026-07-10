import 'package:flutter/material.dart';

class Concept {
  final String id;
  final String title;
  final String category; // e.g. "Komponen Fisik", "Proses Logis"
  final IconData icon;
  final String description;

  Concept({
    required this.id,
    required this.title,
    required this.category,
    required this.icon,
    required this.description,
  });
}
