// API call exceptions

class CustomException implements Exception {
  final _message;
  final _prefix;

  CustomException([this._message, this._prefix]);

  @override
  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends CustomException {
  FetchDataException([message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends CustomException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorizedException extends CustomException {
  UnauthorizedException([message]) : super(message, "Unauthorized: ");
}

class InvalidInputException extends CustomException {
  InvalidInputException([message]) : super(message, "Invalid Input: ");
}
