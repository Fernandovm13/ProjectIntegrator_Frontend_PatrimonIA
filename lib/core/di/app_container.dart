import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/api_client.dart';
import '../storage/token_storage.dart';

class AppContainerNotifier extends Notifier<AppContainer?> {
  @override
  AppContainer? build() => null;

  Future<void> init() async {
    final container = AppContainer();
    await container.init();
    state = container;
  }
}

final appContainerProvider =
    NotifierProvider<AppContainerNotifier, AppContainer?>(
      AppContainerNotifier.new,
    );

class AppContainer {
  final tokenStorage = TokenStorage();
  late final ApiClient apiClient;

  Future<void> init() async {
    await tokenStorage.getToken();
    apiClient = ApiClient(
      baseUrl: 'https://api.patrimonia.app/graphql',
      tokenStorage: tokenStorage,
    );
  }
}
