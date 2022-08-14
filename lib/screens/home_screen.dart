import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deriv_flutter_task/states/price/price_cubit.dart';
import 'package:deriv_flutter_task/states/markets/markets_cubit.dart';
import 'package:deriv_flutter_task/data/models/asset.dart';
import 'package:deriv_flutter_task/data/models/market.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Set<Market> _markets;
  String? _selectedMarketName;
  String? _selectedAssetName;
  double? _lastPrice;
  double? _currentPrice;

  @override
  void initState() {
    BlocProvider.of<MarketsCubit>(context).loadMarkets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MarketsCubit, MarketsState>(builder: (context, state) {
      if (state is MarketsLoaded) {
        _markets = (state).markets;
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    DropdownButtonFormField<String>(
                      hint: const Text('Select a Market'),
                      items: _markets.map<DropdownMenuItem<String>>((market) {
                        return DropdownMenuItem<String>(
                          value: market.name,
                          child: Text(market.name),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedMarketName = newValue;
                          _selectedAssetName = null;
                          _lastPrice = null;
                          _currentPrice = null;
                        });
                      },
                    ),
                    DropdownButtonFormField<String>(
                      hint: const Text('Select an Asset'),
                      items: _selectedMarketName == null
                          ? []
                          : _markets
                              .firstWhere((market) =>
                                  market.name == _selectedMarketName)
                              .assets
                              .map<DropdownMenuItem<String>>((Asset asset) {
                              return DropdownMenuItem<String>(
                                value: asset.displayName,
                                child: Text(asset.displayName),
                              );
                            }).toList(),
                      value: _selectedAssetName,
                      onChanged: (String? newValue) {
                        _handleChooseAsset(newValue!);
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: Center(
                    child: BlocBuilder<PriceCubit, PriceState>(
                      builder: (context, state) {
                        if (state is LoadingPriceStream) {
                          return const CircularProgressIndicator();
                        } else if (state is PriceUpdated) {
                          _lastPrice = _currentPrice;
                          _currentPrice = (state).price;

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Price:',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                '${(state).price}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: (_lastPrice == null ||
                                          _currentPrice! == _lastPrice!)
                                      ? Colors.grey
                                      : _currentPrice! > _lastPrice!
                                          ? Colors.green
                                          : Colors.red,
                                ),
                              ),
                            ],
                          );
                        } else if (state is MarketIsClosed) {
                          return Text(
                            (state).errorMessage,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
    });
  }

  void _handleChooseAsset(String newValue) {
    setState(() {
      _selectedAssetName = newValue;
      _lastPrice = null;
      _currentPrice = null;
    });

    final Market selectedMarket =
        _markets.firstWhere((market) => market.name == _selectedMarketName);

    final Asset selectedAsset = selectedMarket.assets
        .firstWhere((asset) => asset.displayName == _selectedAssetName);

    BlocProvider.of<PriceCubit>(context).loadPriceStream(selectedAsset.symbol);
  }
}
