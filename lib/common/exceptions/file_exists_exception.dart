class FileExistsOnServerException implements Exception {
  String message;

  FileExistsOnServerException(this.message);

  String toString() => 'File exists on server: $message';
}
