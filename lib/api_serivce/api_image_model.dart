class ApiImageModel {
  final String keyName;
  final dynamic file;
  final bool isFromWeb;

  ApiImageModel(
      {required this.file, required this.isFromWeb, required this.keyName});
}
