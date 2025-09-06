class NetworkException implements Exception {
  NetworkException(this.message);
  final String message;
  @override
  String toString() => message;
}

class ValidationException extends NetworkException {
  ValidationException(String message, Map<String, dynamic> errors)
    : super(_formatErrors(message, errors));

  static String _formatErrors(String message, Map<String, dynamic> errors) {
    final allErrors = <String>[];
    errors.forEach((field, errorList) {
      if (errorList is List) {
        allErrors.addAll(errorList.map((e) => e.toString()));
      }
    });
    return allErrors.join('\n');
  }
}
