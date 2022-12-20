class BaseException extends Error {
  final String message;
  BaseException(this.message);

  @override
  String toString() => message;
}
