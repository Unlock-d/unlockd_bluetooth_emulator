typedef FilePath = String;

typedef Json = Map<String, dynamic>;

typedef ReadJsonFile = dynamic Function(FilePath path);

sealed class FileHandlingException implements Exception {}

class FileReadException extends FileHandlingException {}

class FileWriteException extends FileHandlingException {}

class ConfigFileParsingException extends FileHandlingException {}
