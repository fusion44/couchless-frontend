class UploadException implements Exception {
  String message;

  UploadException(this.message);

  String toString() => 'Error uploading file: $message';
}
