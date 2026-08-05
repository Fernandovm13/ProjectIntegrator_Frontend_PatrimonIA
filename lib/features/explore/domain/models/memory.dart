import 'package:flutter/material.dart';

class Memory {
  final String id;
  final String title;
  final String category;
  final String location;
  final String community;
  final String content;
  final String author;
  final String duration;
  final IconData icon;
  final Color color;
  final DateTime createdAt;
  final bool isFeatured;
  final String? audioPath;
  final int likes;
  final int listens;

  Memory({
    required this.id,
    required this.title,
    required this.category,
    required this.location,
    this.community = 'San Cristóbal de las Casas',
    required this.content,
    this.author = 'Anónimo',
    this.duration = '3 min',
    this.icon = Icons.eco,
    this.color = const Color(0xFF1A5C3A),
    DateTime? createdAt,
    this.isFeatured = false,
    this.audioPath,
    this.likes = 0,
    this.listens = 0,
  }) : createdAt = createdAt ?? DateTime.now();
}
