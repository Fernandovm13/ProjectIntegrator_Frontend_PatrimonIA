import '../models/memory.dart';

abstract class MemoryRepository {
  Future<List<Memory>> getMemories();

  Future<void> addMemory(Memory memory);
}
