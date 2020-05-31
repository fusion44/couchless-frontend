class ImportException implements Exception {
  String message;

  ImportException(this.message);

  String toString() => 'Error importing file: $message';
}
