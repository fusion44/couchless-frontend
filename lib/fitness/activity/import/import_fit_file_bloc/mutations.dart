part of 'import_fit_file_bloc.dart';

FutureOr<MutationOptions> _getUploadFITFileMutation(File f) async {
  var multiFile = await multipartFileFrom(f);
  return MutationOptions(documentNode: gql('''
mutation UploadFile (\$file: Upload!) {
  singleUpload(file: \$file) {
    id
    fileName
    createdAt
  }
}
'''), variables: {'file': multiFile});
}

MutationOptions _getImportFITFileMutation(String id, String comment) {
  return MutationOptions(documentNode: gql('''
mutation ImportActivity {
  importActivity(input: { fileID: "$id", comment: "$comment" }) {
    id
    createdAt
    startTime
    endTime
    comment
    sportType
    user {
      id
      username
      email
      createdAt
      updatedAt
    }
  }
}
'''));
}
