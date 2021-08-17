class HtppException implements Exception {
  final String msg;

  const HtppException(this.msg);

  @override
  String toString() {
    return msg;
  }
}