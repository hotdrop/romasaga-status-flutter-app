class RSException implements Exception {
  const RSException({required this.message});

  final String message;

  @override
  String toString() => message;
}
