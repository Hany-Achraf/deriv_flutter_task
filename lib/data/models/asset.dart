class Asset {
  late String _displayName;
  late String _symbol;

  Asset({required String displayName, required String symbol}) {
    _displayName = displayName;
    _symbol = symbol;
  }

  String get displayName => _displayName;
  String get symbol => _symbol;
}
