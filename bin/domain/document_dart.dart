class DocumentDart {
  final Future<bool> instanceStatus;

  DocumentDart() : instanceStatus = _loadData();

  static Future<bool> _loadData() async {
    await Future.delayed(Duration(seconds: 1));
    return true;
  }
}
