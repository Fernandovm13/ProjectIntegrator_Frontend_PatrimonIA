import '../../domain/models/memory.dart';
import '../../domain/repositories/memory_repository.dart';
import '../datasources/memory_local_datasource.dart';

class MemoryRepositoryImpl implements MemoryRepository {
  final MemoryLocalDataSource localDataSource;

  const MemoryRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Memory>> getMemories() {
    return localDataSource.getMemories();
  }

  @override
  Future<void> addMemory(Memory memory) {
    return localDataSource.addMemory(memory);
  }
}
