import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fit2json/models/activity.dart';
import 'package:get/get.dart';
import 'package:graphql/client.dart';
import 'package:graphql/utilities.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart' as p;

import '../../../../common/exceptions/exceptions.dart';
import '../../../../common/exceptions/import_exception.dart';
import '../../../../common/models/models.dart';
import '../local_fit_file_info.dart';

part 'import_fit_file_data.dart';
part 'import_fit_file_event.dart';
part 'import_fit_file_state.dart';
part 'mutations.dart';

class ImportFitFileBloc
    extends Bloc<ImportFitFileBaseEvent, ImportFitFileBaseState> {
  Box box;
  ImportFitFileBloc() : super(ImportFitFileInitial()) {
    _openBox();
  }

  void _openBox() async {
    box = await Hive.openBox('ImportedFitFiles');
  }

  @override
  Future<void> close() async {
    await box.close();
    return super.close();
  }

  @override
  Stream<ImportFitFileBaseState> mapEventToState(
    ImportFitFileBaseEvent event,
  ) async* {
    if (event is CheckImportStatusEvent) {
      var map = <String, ImportFitFileData>{};

      for (var f in event.files) {
        var status = Status.queued;
        var fileName = p.basename(f.file.path);
        if (box.containsKey(fileName)) {
          status = Status.imported;
        }
        map[f.file.path] = ImportFitFileData(
          f.file.path,
          fileName,
          "",
          status,
        );
      }

      yield CheckFitImportStatusUpdate(map);
    } else if (event is ImportFitFilesEvent) {
      for (var file in event.files) {
        try {
          if (file.status == Status.queued) {
            yield ImportFitFileUpdate(file.copyWith(status: Status.working));
            await Future.delayed(Duration(milliseconds: 250));
            var fileDescriptor = await _upload(File(file.filePath));
            var activity = await _import(fileDescriptor, file.comment);
            await box.put(file.fileName, true);
            yield ImportFitFileUpdate(file.copyWith(status: Status.imported));
          }
        } on FileExistsOnServerException catch (e) {
          // When the file exists on the server we consider it imported
          yield ImportFitFileUpdate(
            file.copyWith(
              status: Status.imported,
              error: e.message,
            ),
          );
        } on UploadException catch (e) {
          yield ImportFitFileUpdate(
            file.copyWith(
              status: Status.error,
              error: e.message,
            ),
          );
        } on ImportException catch (e) {
          yield ImportFitFileUpdate(
            file.copyWith(
              status: Status.error,
              error: e.message,
            ),
          );
        }
      }
    }
  }

  FutureOr<FileDescriptor> _upload(File file) async {
    var client = Get.find<GraphQLClient>();
    final res = await client.mutate(await _getUploadFITFileMutation(file));

    if (res.hasException) {
      for (var e in res.exception.graphqlErrors) {
        if (e.message.contains('File exists')) {
          throw FileExistsOnServerException(e.message);
        } else {
          print(e.message);
        }
      }

      throw UploadException("Error Uploading ${file.path}");
    }

    return FileDescriptor.fromJson(res.data['singleUpload']);
  }

  FutureOr<Activity> _import(FileDescriptor fd, String comment) async {
    var client = Get.find<GraphQLClient>();
    var opts = _getImportFITFileMutation(fd.id, comment);
    final res = await client.mutate(opts);

    if (res.hasException) {
      print('Errors');
      print(res.exception);
      throw ImportException("Error Importing ${fd.fileName}");
    }

    return Activity.fromJson(res.data['importActivity']);
  }
}
