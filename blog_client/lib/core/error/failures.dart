import 'package:blog_client/core/constants/constants.dart';

class Failure {
  Failure([this.message = AppConstants.defaultError, this.validationErrors]);

  final String message;
  final Map<String, List<String>>? validationErrors;

  String? getFirstErrorFor(String field) {
    return validationErrors?[field]?.first;
  }

  List<String> getAllErrors() {
    final allErrors = <String>[];
    validationErrors?.forEach((field, errors) {
      allErrors.addAll(errors);
    });
    return allErrors;
  }
}
