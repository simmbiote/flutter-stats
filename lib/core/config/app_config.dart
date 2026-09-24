class AppConfig {
  const AppConfig({
    required this.apiBaseUrl,
    required this.clientVersion,
    this.enableAutomaticSync = true,
    this.useFakeHealthSource = false,
    this.useFakeApi = false,
  });

  factory AppConfig.fromEnvironment() {
    return const AppConfig(
      apiBaseUrl: String.fromEnvironment(
        'HEALTH_API_BASE_URL',
        defaultValue: '',
      ),
      clientVersion: String.fromEnvironment(
        'HEALTH_CLIENT_VERSION',
        defaultValue: '1.0.0',
      ),
      enableAutomaticSync: bool.fromEnvironment(
        'HEALTH_ENABLE_AUTOMATIC_SYNC',
        defaultValue: true,
      ),
      useFakeHealthSource: bool.fromEnvironment(
        'HEALTH_USE_FAKE_SOURCE',
        defaultValue: false,
      ),
      useFakeApi: bool.fromEnvironment(
        'HEALTH_USE_FAKE_API',
        defaultValue: false,
      ),
    );
  }

  final String apiBaseUrl;
  final String clientVersion;
  final bool enableAutomaticSync;
  final bool useFakeHealthSource;
  final bool useFakeApi;

  bool get hasApiBaseUrl => apiBaseUrl.trim().isNotEmpty;
  bool get isDevelopmentMode => useFakeHealthSource || useFakeApi;
}
