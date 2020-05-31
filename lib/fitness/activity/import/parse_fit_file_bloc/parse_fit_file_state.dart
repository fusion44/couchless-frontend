part of 'parse_fit_file_bloc.dart';

abstract class ParseFitFileBaseState extends Equatable {
  const ParseFitFileBaseState();
}

class ParseFitFileInitial extends ParseFitFileBaseState {
  @override
  List<Object> get props => [];
}

class FitFileParsed extends ParseFitFileBaseState {
  final String fileName;
  final PrettyFit fitFile;

  FitFileParsed(this.fileName, this.fitFile);

  @override
  List<Object> get props => [fileName, fitFile];
}
