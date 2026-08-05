import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/explore_di.dart';
import '../../domain/models/memory.dart';
import '../../domain/usecases/add_memory_usecase.dart';
import '../../domain/usecases/get_memories_usecase.dart';

final _getMemoriesUsecaseProvider = Provider<GetMemoriesUsecase>((ref) {
  return ref.watch(exploreDIProvider).getMemoriesUsecase;
});

final _addMemoryUsecaseProvider = Provider<AddMemoryUsecase>((ref) {
  return ref.watch(exploreDIProvider).addMemoryUsecase;
});

class MemoryState {
  final List<Memory> memories;

  const MemoryState({this.memories = const []});

  MemoryState copyWith({List<Memory>? memories}) {
    return MemoryState(memories: memories ?? this.memories);
  }
}

class MemoryNotifier extends AsyncNotifier<MemoryState> {
  @override
  Future<MemoryState> build() async {
    final memories = await ref.read(_getMemoriesUsecaseProvider)();
    return MemoryState(memories: memories);
  }

  Memory? get featuredMemory {
    for (final memory in state.requireValue.memories) {
      if (memory.isFeatured) return memory;
    }
    return null;
  }

  List<Memory> recent() {
    final list = List<Memory>.from(state.requireValue.memories)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  List<Memory> byCategory(String category) {
    if (category == 'Todos') return state.requireValue.memories;
    return state.requireValue.memories
        .where((m) => m.category == category)
        .toList();
  }

  List<Memory> search(String query) {
    if (query.isEmpty) return [];
    final q = query.toLowerCase();
    return state.requireValue.memories
        .where(
          (m) =>
              m.title.toLowerCase().contains(q) ||
              m.content.toLowerCase().contains(q) ||
              m.category.toLowerCase().contains(q) ||
              m.location.toLowerCase().contains(q),
        )
        .toList();
  }

  Future<void> addMemory(Memory memory) async {
    await ref.read(_addMemoryUsecaseProvider)(memory);
    state = AsyncValue.data(
      state.requireValue.copyWith(
        memories: [memory, ...state.requireValue.memories],
      ),
    );
  }

  void toggleLike(String id) {
    final updated = state.requireValue.memories.map((m) {
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

    state = AsyncValue.data(state.requireValue.copyWith(memories: updated));
  }
}

final memoryProvider = AsyncNotifierProvider<MemoryNotifier, MemoryState>(
  MemoryNotifier.new,
);
