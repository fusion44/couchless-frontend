part of 'import_fit_file_bloc.dart';

enum Status { queued, working, imported, error }

class ImportFitFileData {
  final String filePath;
  final String fileName;
  final String comment;
  final Status status;
  final String error;

  ImportFitFileData(
    this.filePath,
    this.fileName,
    this.comment, [
    this.status = Status.queued,
    this.error = '',
  ]);

  ImportFitFileData copyWith({
    String filePath,
    String fileName,
    String comment,
    Status status,
    String error,
  }) {
    return ImportFitFileData(
      filePath = filePath ?? this.filePath,
      fileName = fileName ?? this.fileName,
      comment = comment ?? this.comment,
      status = status ?? this.status,
      error = error ?? this.error,
    );
  }
}
