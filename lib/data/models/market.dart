import 'package:deriv_flutter_task/data/models/asset.dart';

class Market {
  late String _name;
  final Set<Asset> _assets = {};

  Market({required String name}) {
    _name = name;
  }

  void addAsset({required Asset asset}) => _assets.add(asset);

  String get name => _name;
  Set<Asset> get assets => _assets;
}
