part of 'price_cubit.dart';

@immutable
abstract class PriceState {}

class PriceInitial extends PriceState {}

class LoadingPriceStream extends PriceState {}

class PriceUpdated extends PriceState {
  final double price;
  PriceUpdated(this.price);
}

class MarketIsClosed extends PriceState {
  final String errorMessage;
  MarketIsClosed(this.errorMessage);
}
