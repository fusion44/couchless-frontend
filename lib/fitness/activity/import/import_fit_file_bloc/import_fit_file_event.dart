part of 'import_fit_file_bloc.dart';

abstract class ImportFitFileBaseEvent extends Equatable {
  const ImportFitFileBaseEvent();
}

class CheckImportStatusEvent extends ImportFitFileBaseEvent {
  final List<FitFileInfo> files;

  CheckImportStatusEvent(this.files);

  @override
  List<Object> get props => files;
}

class ImportFitFilesEvent extends ImportFitFileBaseEvent {
  final List<ImportFitFileData> files;

  ImportFitFilesEvent(this.files);

  @override
  List<Object> get props => files;
}
