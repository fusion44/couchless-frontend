import 'dart:io';

import 'package:fit2json/models/pretty_fit.dart';
import 'package:flutter/material.dart';
import 'package:glob/glob.dart';

import '../../../common/constants.dart';
import 'import_fit_file_bloc/import_fit_file_bloc.dart';
import 'import_fit_file_list.dart';
import 'local_fit_file_info.dart';
import 'parse_fit_file_bloc/parse_fit_file_bloc.dart';

class ImportFitFile extends StatefulWidget {
  @override
  _ImportFitFileState createState() => _ImportFitFileState();
}

class _ImportFitFileState extends State<ImportFitFile> {
  ParseFitFileBloc _parseFitFileBloc = ParseFitFileBloc();
  ImportFitFileBloc _importFitFileBloc = ImportFitFileBloc();

  List<FitFileInfo> _files = [];
  Map<String, PrettyFit> _parsedFiles = {};
  Map<String, ImportFitFileData> _importData = {};

  int _numTotalFilesToImport = 0;
  int _numFinishedFiles = 0;
  bool _importing = false;

  bool _finished = true;

  @override
  void initState() {
    _parseFitFileBloc.listen((state) {
      if (state is FitFileParsed) {
        setState(() {
          _parsedFiles[state.fileName] = state.fitFile;
        });
      }
    });
    _importFitFileBloc.listen((state) {
      if (state is CheckFitImportStatusUpdate) {
        setState(() {
          _finished = !state.files.values
              .any((element) => element.status == Status.queued);
          _importData = state.files;
        });
      } else if (state is ImportFitFileUpdate) {
        setState(() {
          if (state.data.status == Status.working) {
            _numFinishedFiles += 1;
            if (_numFinishedFiles == _numTotalFilesToImport) {
              _importing = false;
              _finished = true;
            }
          }
          _importData[state.data.filePath] = state.data;
        });
      }
    });
    _findDevice();
    super.initState();
  }

  @override
  void dispose() {
    _parseFitFileBloc.close();
    _importFitFileBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _importing
            ? IconButton(
                onPressed: () {},
                icon: Icon(Icons.arrow_back),
              )
            : null,
        title: Text('Import Garmin Activity'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              child: Text('Import All'),
              onPressed: !_finished ? _importAll : null,
            ),
          )
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_importing) {
      return Column(
        children: [
          LinearProgressIndicator(
            value: (1 / _numTotalFilesToImport) * _numFinishedFiles,
          ),
          Expanded(
            child: ImportFitFileList(
              files: _files,
              parsedFiles: _parsedFiles,
              importData: _importData,
            ),
          )
        ],
      );
    } else {
      return ImportFitFileList(
        files: _files,
        parsedFiles: _parsedFiles,
        importData: _importData,
      );
    }
  }

  void _findDevice() async {
    var home =
        Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];

    var userName = '';
    if (Platform.isLinux) {
      if (home.contains('/home/')) {
        userName = home.replaceAll('/home/', '');
      }
    }

    var paths = [
      '/run/media/$userName/',
    ];

    var fileList = <FitFileInfo>[];

    for (var path in paths) {
      var glob = Glob('$path/**.FIT');
      for (var entity in glob.listSync()) {
        var stat = await entity.stat();
        if (entity.path.contains('ACTIVITY')) {
          fileList.add(FitFileInfo(entity, stat, FitFileType.Activity));
          _parseFitFileBloc.add(ParseFitFile(entity.path));
        }
      }
    }

    fileList.sort((a, b) => b.stat.modified.compareTo(a.stat.modified));

    _importFitFileBloc.add(CheckImportStatusEvent(fileList));

    setState(() {
      _files = fileList;
    });
  }

  void _importAll() {
    var l = <ImportFitFileData>[];
    for (var f in _importData.values) {
      if (f.status == Status.queued) l.add(f.copyWith());
    }
    _importFitFileBloc.add(ImportFitFilesEvent(l));
    setState(() {
      _importing = true;
      _numTotalFilesToImport = l.length;
    });
  }
}
