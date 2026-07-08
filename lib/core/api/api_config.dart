class ApiConfig {
  final String baseUrl;

  const ApiConfig({
    this.baseUrl = const String.fromEnvironment(
      'PATRIMONIA_API_BASE_URL',
      defaultValue: 'http://10.0.2.2:8080/api',
    ),
  });
}
