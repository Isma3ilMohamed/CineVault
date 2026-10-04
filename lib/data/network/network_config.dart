/// What the HTTP client needs from the app's build config. The app registers
/// one before the data module is initialized.
class NetworkConfig {
  const NetworkConfig({
    required this.baseUrl,
    required this.accessToken,
    this.enableNetworkLogs = false,
  });

  final String baseUrl;
  final String accessToken;
  final bool enableNetworkLogs;
}
