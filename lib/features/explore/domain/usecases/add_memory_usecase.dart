import '../models/memory.dart';
import '../repositories/memory_repository.dart';

class AddMemoryUsecase {
  final MemoryRepository _repository;

  const AddMemoryUsecase({required MemoryRepository repository})
      : _repository = repository;

  Future<void> call(Memory memory) {
    return _repository.addMemory(memory);
  }
}
