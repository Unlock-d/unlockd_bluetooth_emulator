typedef FilePath = String;

typedef Json = Map<String, dynamic>;

typedef ReadJsonFile = dynamic Function(FilePath path);

sealed class ReaderException implements Exception {}

class FileReadException extends ReaderException {}

class ConfigFileParsingException extends ReaderException {}
