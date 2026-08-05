import '../models/memory.dart';
import '../repositories/memory_repository.dart';

class GetMemoriesUsecase {
  final MemoryRepository _repository;

  const GetMemoriesUsecase({required MemoryRepository repository})
      : _repository = repository;

  Future<List<Memory>> call() {
    return _repository.getMemories();
  }
}
