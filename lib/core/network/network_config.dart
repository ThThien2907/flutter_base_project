class NetworkConfig {
  const NetworkConfig({
    required this.baseUrl,
    this.imageEndpoint = '',
    this.connectTimeout = const Duration(seconds: 30),
    this.receiveTimeout = const Duration(seconds: 30),
    this.sendTimeout = const Duration(seconds: 30),
    this.uploadReceiveTimeout = const Duration(seconds: 120),
    this.uploadSendTimeout = const Duration(seconds: 120),
    this.defaultHeaders = const {
      'accept': 'application/json',
      'Content-Type': 'application/json',
    },
  });

  final String baseUrl;
  final String imageEndpoint;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final Duration sendTimeout;
  final Duration uploadReceiveTimeout;
  final Duration uploadSendTimeout;
  final Map<String, dynamic> defaultHeaders;
}
