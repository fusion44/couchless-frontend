class FileDescriptor {
  String id;
  String fileName;
  String createdAt;

  FileDescriptor({this.id, this.fileName, this.createdAt});

  FileDescriptor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fileName = json['fileName'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['id'] = this.id;
    data['fileName'] = this.fileName;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
