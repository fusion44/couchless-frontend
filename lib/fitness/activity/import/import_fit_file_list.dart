import 'package:fit2json/models/pretty_fit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../common/sport_utils.dart';
import 'import_fit_file_bloc/import_fit_file_bloc.dart';
import 'local_fit_file_info.dart';

class ImportFitFileList extends StatelessWidget {
  final List<FitFileInfo> _files;
  final Map<String, PrettyFit> _parsedFiles;
  final Map<String, ImportFitFileData> _importData;

  const ImportFitFileList({
    Key key,
    @required List<FitFileInfo> files,
    @required Map<String, PrettyFit> parsedFiles,
    @required Map<String, ImportFitFileData> importData,
  })  : _files = files,
        _parsedFiles = parsedFiles,
        _importData = importData,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView.builder(
        itemCount: _files.length,
        itemBuilder: (context, i) {
          var modDate = timeago.format(_files[i].stat.modified);
          return _buildListTile(i, modDate);
        },
      ),
    );
  }

  ListTile _buildListTile(int i, String modificationDate) {
    var filePath = _files[i].file.path;
    PrettyFit fitFile;
    if (_parsedFiles.containsKey(filePath)) {
      fitFile = _parsedFiles[filePath];
    }

    String errorMessage = "";
    if (_importData.containsKey(filePath) &&
        _importData[filePath].status == Status.error) {
      errorMessage = _importData[filePath].error;
    }

    return ListTile(
      isThreeLine: errorMessage.isNotEmpty,
      title: Text(filePath),
      leading: fitFile == null ? _buildLoading() : _buildSportIcon(fitFile),
      subtitle: Row(
        children: <Widget>[
          SizedBox(
            width: 120,
            child: Text(
              '${(_files[i].stat.size / 1000).toStringAsFixed(2)} kB',
            ),
          ),
          Text('Modified: $modificationDate'),
        ],
      ),
      trailing:
          _importData.containsKey(filePath) ? _buildImportIcon(filePath) : null,
    );
  }

  Widget _buildLoading() {
    return Container(
      width: 150,
      height: 150,
      child: SpinKitFadingCircle(
        itemBuilder: (BuildContext context, int index) {
          return DecoratedBox(
            decoration: BoxDecoration(
              color: index.isEven ? Colors.red : Colors.green,
            ),
          );
        },
      ),
    );
  }

  Widget _buildSportIcon(PrettyFit fit) {
    assert(fit != null);

    if (fit.session == null) {
      return Icon(FontAwesome5Solid.times);
    }

    return getIconForSport(fit.session.sport);
  }

  Widget _buildImportIcon(String filePath) {
    var data = _importData[filePath];
    if (data.status == Status.queued) {
      return Tooltip(
        message: 'Waiting to be synced',
        child: Icon(Icons.sync, color: Colors.orange),
      );
    } else if (data.status == Status.working) {
      return Tooltip(
        message: 'Syncing file',
        child: _buildLoading(),
      );
    } else if (data.status == Status.imported) {
      return Tooltip(
        message: 'Successfully imported',
        child: Icon(Icons.done, color: Colors.green),
      );
    } else if (data.status == Status.error) {
      return Tooltip(
        message: 'An error occurred: ${data.error}',
        child: Icon(Icons.error_outline),
      );
    } else {
      return Icon(Icons.device_unknown);
    }
  }
}
