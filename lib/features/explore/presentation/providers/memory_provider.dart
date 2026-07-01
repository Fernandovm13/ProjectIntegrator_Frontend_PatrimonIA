import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/memory.dart';
import '../../../../shared/theme/app_colors.dart';

List<Memory> _seedMemories() {
  return [
    Memory(
      id: '1',
      title: 'El Nagual del Cerro Tzontehuitz',
      category: 'Leyenda',
      location: 'Chamula',
      community: 'San Cristóbal de las Casas',
      content:
          'Cuentan los abuelos en Los Altos de Chiapas que el Cerro Tzontehuitz no es una simple elevación de tierra y árboles, sino el hogar de protectores antiguos que cambian de forma al caer el crepúsculo.\n\n'
          'Aquellos hombres sabios, conocidos como Naguales, asumen el espíritu de jaguares o serpientes emplumadas para vigilar que los cazadores y recolectores respeten los ciclos de la madre tierra.\n\n'
          'Si entras al cerro con malas intenciones, una densa neblina impregnada con aroma a copal bloqueará tu sendero, y escucharás un rugido profundo que te recordará que el patrimonio no se vende, se venera...',
      author: 'Doña Caterina Gómez',
      duration: '3 min',
      icon: Icons.eco,
      color: AppColors.categoryLeyenda,
      isFeatured: true,
      likes: 24,
      listens: 156,
      createdAt: DateTime(2024, 3),
    ),
    Memory(
      id: '2',
      title: 'El Sombrerón de Zinacantán',
      category: 'Leyenda',
      location: 'San Cristóbal',
      community: 'Zinacantán',
      content:
          'Se dice que en los caminos de Zinacantán aparece un hombre pequeño con un sombrero grande que seduce a las mujeres con su guitarra...',
      author: 'Don Mariano Pérez',
      duration: '3 min',
      icon: Icons.eco,
      color: AppColors.categoryLeyenda,
      likes: 18,
      listens: 92,
    ),
    Memory(
      id: '3',
      title: 'La Milpa Sagrada',
      category: 'Tradición',
      location: 'Chamula',
      community: 'Chamula',
      content:
          'Cada año, antes de la siembra, se realiza una ceremonia para pedir permiso a la tierra. El maíz no es solo alimento, es vida...',
      author: 'María López',
      duration: '4 min',
      icon: Icons.agriculture,
      color: AppColors.categoryTradicion,
      likes: 12,
      listens: 67,
    ),
    Memory(
      id: '4',
      title: 'Danza del Jaguar',
      category: 'Ritual',
      location: 'Tenejapa',
      community: 'Tenejapa',
      content:
          'La danza del jaguar es una de las tradiciones más antiguas de Tenejapa. Los danzantes se visten con pieles de jaguar y ejecutan movimientos que imitan al felino sagrado...',
      author: 'Antonio Gómez',
      duration: '5 min',
      icon: Icons.music_note,
      color: AppColors.categoryRitual,
      likes: 31,
      listens: 203,
    ),
    Memory(
      id: '5',
      title: 'La Llorona en el Río Amarillo',
      category: 'Leyenda',
      location: 'San Cristóbal',
      community: 'San Cristóbal de las Casas',
      content: 'Las noches de luna llena, dicen los ancianos, se escucha el llanto de una mujer que busca a sus hijos junto al río...',
      author: 'Doña Caterina Gómez',
      duration: '3 min',
      icon: Icons.eco,
      color: AppColors.categoryLeyenda,
      likes: 9,
      listens: 45,
    ),
    Memory(
      id: '6',
      title: 'El rezo del maíz nuevo',
      category: 'Tradición',
      location: 'Chamula',
      community: 'Chamula',
      content: 'Cuando la milpa da sus primeros elotes, la comunidad entera se reúne para agradecer...',
      author: 'Pedro Hernández',
      duration: '4 min',
      icon: Icons.agriculture,
      color: AppColors.categoryTradicion,
      likes: 7,
      listens: 38,
    ),
    Memory(
      id: '7',
      title: 'Avistamientos en Los Altos (1974)',
      category: 'Historia',
      location: 'Tenejapa',
      community: 'Tenejapa',
      content: 'Un registro oral sobre crónicas comunitarias que detallan encuentros con un supuesto nagual felino...',
      author: 'Archivo Comunitario',
      duration: '8 min',
      icon: Icons.menu_book,
      color: AppColors.categoryHistoria,
      likes: 15,
      listens: 89,
    ),
    Memory(
      id: '8',
      title: 'Los Caracoles de la Danza',
      category: 'Tradición',
      location: 'Zinacantán',
      community: 'Zinacantán',
      content: 'Los caracoles marinos son utilizados como instrumento ceremonial en las festividades...',
      author: 'Ana López',
      duration: '2 min',
      icon: Icons.library_music,
      color: AppColors.categoryCancion,
      likes: 5,
      listens: 22,
    ),
  ];
}

class MemoryNotifier extends StateNotifier<List<Memory>> {
  MemoryNotifier() : super(_seedMemories());

  List<Memory> get featured => state.where((m) => m.isFeatured).toList();
  List<Memory> get recent => List.from(state)..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  List<Memory> byCategory(String category) {
    if (category == 'Todos') return state;
    return state.where((m) => m.category == category).toList();
  }

  List<Memory> search(String query) {
    if (query.isEmpty) return [];
    final q = query.toLowerCase();
    return state.where((m) =>
      m.title.toLowerCase().contains(q) ||
      m.content.toLowerCase().contains(q) ||
      m.category.toLowerCase().contains(q) ||
      m.location.toLowerCase().contains(q)
    ).toList();
  }

  void addMemory(Memory memory) {
    state = [memory, ...state];
  }

  void toggleLike(String id) {
    state = state.map((m) {
      if (m.id == id) {
        return Memory(
          id: m.id,
          title: m.title,
          category: m.category,
          location: m.location,
          community: m.community,
          content: m.content,
          author: m.author,
          duration: m.duration,
          icon: m.icon,
          color: m.color,
          createdAt: m.createdAt,
          isFeatured: m.isFeatured,
          audioPath: m.audioPath,
          likes: m.likes + 1,
          listens: m.listens,
        );
      }
      return m;
    }).toList();
  }
}

final memoryProvider = StateNotifierProvider<MemoryNotifier, List<Memory>>((ref) {
  return MemoryNotifier();
});

final featuredMemoryProvider = Provider<Memory?>((ref) {
  final memories = ref.watch(memoryProvider);
  return memories.cast<Memory?>().firstWhere(
    (m) => m!.isFeatured,
    orElse: () => null,
  );
});
