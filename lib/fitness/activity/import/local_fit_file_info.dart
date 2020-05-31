import 'dart:io';

import '../../../common/constants.dart';

class FitFileInfo {
  final FileSystemEntity file;
  final FileStat stat;
  final FitFileType type;

  FitFileInfo(this.file, this.stat, this.type);
}
