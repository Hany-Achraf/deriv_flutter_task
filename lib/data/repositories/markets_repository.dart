import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:deriv_flutter_task/data/api/api_service.dart';
import 'package:deriv_flutter_task/data/models/asset.dart';
import 'package:deriv_flutter_task/data/models/market.dart';

class MarketsRepository {
  final Set<Market> _allMarkets = {};
  final ApiService _apiService = ApiService();

  Future<Set<Market>> getAllMarkets() {
    final activeSymbolsJsonChannel = _apiService.getActiveSymbolsChannel();

    return activeSymbolsJsonChannel.stream
        .listen((activeSymbolsJson) {
          Map<String, dynamic> activeSymbols = json.decode(activeSymbolsJson);

          for (var activeSymbol in activeSymbols['active_symbols']) {
            Market? searchedMarket = _allMarkets.firstWhereOrNull(
                (market) => market.name == activeSymbol['market_display_name']);

            if (searchedMarket == null) {
              Market newMarket =
                  Market(name: activeSymbol['market_display_name']);

              newMarket.addAsset(
                asset: Asset(
                  displayName: activeSymbol['display_name'],
                  symbol: activeSymbol['symbol'],
                ),
              );
              _allMarkets.add(newMarket);
            } else {
              searchedMarket.addAsset(
                asset: Asset(
                  displayName: activeSymbol['display_name'],
                  symbol: activeSymbol['symbol'],
                ),
              );
            }
          }
          activeSymbolsJsonChannel.sink.close();
        })
        .asFuture()
        .then((_) => _allMarkets);
  }
}
