part of 'parse_fit_file_bloc.dart';

abstract class ParseFitFileBaseEvent extends Equatable {
  const ParseFitFileBaseEvent();
}

class ParseFitFile extends ParseFitFileBaseEvent {
  final String filePath;

  ParseFitFile(this.filePath);

  @override
  List<Object> get props => [filePath];
}
