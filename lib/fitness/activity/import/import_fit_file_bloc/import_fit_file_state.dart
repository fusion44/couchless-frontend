part of 'import_fit_file_bloc.dart';

abstract class ImportFitFileBaseState extends Equatable {
  const ImportFitFileBaseState();
}

class ImportFitFileInitial extends ImportFitFileBaseState {
  @override
  List<Object> get props => [];
}

class CheckFitImportStatusUpdate extends ImportFitFileBaseState {
  final Map<String, ImportFitFileData> files;

  CheckFitImportStatusUpdate(this.files);

  @override
  List<Object> get props => files.keys.toList();
}

class ImportFitFileUpdate extends ImportFitFileBaseState {
  final ImportFitFileData data;

  ImportFitFileUpdate(this.data);

  @override
  List<Object> get props => [data];
}

class ImportFitFileError extends ImportFitFileBaseState {
  final ImportFitFileData data;

  ImportFitFileError(this.data);

  @override
  List<Object> get props => [data];
}
