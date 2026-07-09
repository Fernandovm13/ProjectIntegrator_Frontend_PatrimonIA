import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_client.dart';

class StoryCategory {
  const StoryCategory({required this.id, required this.name});

  final int id;
  final String name;
}

class StoryCategoryState {
  const StoryCategoryState({
    this.categories = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  final List<StoryCategory> categories;
  final bool isLoading;
  final String? errorMessage;
}

class StoryCategoryNotifier extends StateNotifier<StoryCategoryState> {
  StoryCategoryNotifier(this._apiClient) : super(const StoryCategoryState());

  final ApiClient _apiClient;

  Future<void> load() async {
    state = const StoryCategoryState(isLoading: true);
    try {
      final response = await _apiClient.get('/categories');
      if (!response.isSuccess) {
        throw Exception(
          _errorFrom(response.data) ?? 'No se pudieron cargar las categorias.',
        );
      }
      final categories = _extractList(response.data)
          .map((raw) {
            final json = raw is Map<String, dynamic>
                ? raw
                : <String, dynamic>{};
            final id = _intFrom(json['id']);
            final name = json['name'];
            return id == null || name is! String || name.trim().isEmpty
                ? null
                : StoryCategory(id: id, name: name.trim());
          })
          .whereType<StoryCategory>()
          .toList();
      state = StoryCategoryState(categories: categories);
    } catch (error) {
      state = StoryCategoryState(
        errorMessage: error.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  List<dynamic> _extractList(dynamic data) {
    if (data is List) return data;
    if (data is Map<String, dynamic>) {
      for (final candidate in [
        data['categories'],
        data['data'],
        data['items'],
      ]) {
        if (candidate is List) return candidate;
      }
    }
    return const [];
  }

  String? _errorFrom(dynamic data) {
    if (data is! Map<String, dynamic>) return null;
    final message = data['message'] ?? data['error'];
    return message is String ? message : null;
  }

  int? _intFrom(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return value is String ? int.tryParse(value) : null;
  }
}

final storyCategoryProvider =
    StateNotifierProvider<StoryCategoryNotifier, StoryCategoryState>((ref) {
      final notifier = StoryCategoryNotifier(ref.watch(apiClientProvider));
      Future.microtask(notifier.load);
      return notifier;
    });
