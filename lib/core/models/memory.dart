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
  final int? categoryId;
  final int? communityId;
  final String? status;
  final bool isFavorite;
  final double? latitude;
  final double? longitude;

  Memory({
    required this.id,
    required this.title,
    required this.category,
    required this.location,
    this.community = 'Comunidad',
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
    this.categoryId,
    this.communityId,
    this.status,
    this.isFavorite = false,
    this.latitude,
    this.longitude,
  }) : createdAt = createdAt ?? DateTime.now();

  Memory copyWith({
    String? id,
    String? title,
    String? category,
    String? location,
    String? community,
    String? content,
    String? author,
    String? duration,
    IconData? icon,
    Color? color,
    DateTime? createdAt,
    bool? isFeatured,
    String? audioPath,
    int? likes,
    int? listens,
    int? categoryId,
    int? communityId,
    String? status,
    bool? isFavorite,
    double? latitude,
    double? longitude,
  }) {
    return Memory(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      location: location ?? this.location,
      community: community ?? this.community,
      content: content ?? this.content,
      author: author ?? this.author,
      duration: duration ?? this.duration,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      isFeatured: isFeatured ?? this.isFeatured,
      audioPath: audioPath ?? this.audioPath,
      likes: likes ?? this.likes,
      listens: listens ?? this.listens,
      categoryId: categoryId ?? this.categoryId,
      communityId: communityId ?? this.communityId,
      status: status ?? this.status,
      isFavorite: isFavorite ?? this.isFavorite,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
