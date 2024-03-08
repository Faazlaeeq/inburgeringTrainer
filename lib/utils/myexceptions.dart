class NoInternetException implements Exception {
  final String message;

  NoInternetException({required this.message});

  @override
  String toString() => message;
}
