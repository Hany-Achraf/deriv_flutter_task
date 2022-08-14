part of 'markets_cubit.dart';

@immutable
abstract class MarketsState {}

class MarketsInitial extends MarketsState {}

class MarketsLoaded extends MarketsState {
  final Set<Market> markets;

  MarketsLoaded(this.markets);
}
