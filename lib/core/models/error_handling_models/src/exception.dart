class ServerException implements Exception {
  final String? message;
  ServerException({this.message});
}

class NoConnectionException implements Exception {
  final String? message;
  NoConnectionException({this.message});
}

class DataParsingException implements Exception {
  final String? message;
  DataParsingException({this.message});
}

class DataConversionException implements Exception {
  final String? message;
  DataConversionException({this.message});
}

class MissingDataConversionFunctionException implements Exception {}

class CustomException implements Exception {
  final String? message;
  CustomException({required this.message});
}
