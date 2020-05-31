import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit2json/models/pretty_fit.dart';
import 'package:fit_parser/fit_parser.dart';

part 'parse_fit_file_event.dart';
part 'parse_fit_file_state.dart';

class ParseFitFileBloc
    extends Bloc<ParseFitFileBaseEvent, ParseFitFileBaseState> {
  @override
  ParseFitFileBaseState get initialState => ParseFitFileInitial();

  @override
  Stream<ParseFitFileBaseState> mapEventToState(
    ParseFitFileBaseEvent event,
  ) async* {
    if (event is ParseFitFile) {
      var f = FitFile(path: event.filePath);
      f.parse();
      yield FitFileParsed(event.filePath, PrettyFit.fromFitFile(f));
    }
  }
}
