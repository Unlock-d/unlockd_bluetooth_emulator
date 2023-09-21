typedef FilePath = String;

typedef Json = Map<String, dynamic>;

typedef ReadJsonFile = dynamic Function(FilePath path);

sealed class FileHandlingException implements Exception {
  FileHandlingException(this.cause, this.stackTrace);

  final Object cause;
  final StackTrace stackTrace;
}

class FileReadException extends FileHandlingException {
  FileReadException(super.cause, super.stackTrace);
}

class FileWriteException extends FileHandlingException {
  FileWriteException(super.cause, super.stackTrace);
}

class ConfigFileParsingException extends FileHandlingException {
  ConfigFileParsingException(super.cause, super.stackTrace);
}
