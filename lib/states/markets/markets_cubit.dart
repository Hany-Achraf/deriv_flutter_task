import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:deriv_flutter_task/data/models/market.dart';
import 'package:deriv_flutter_task/data/repositories/markets_repository.dart';

part 'markets_state.dart';

class MarketsCubit extends Cubit<MarketsState> {
  final MarketsRepository marketsRepository;

  MarketsCubit(this.marketsRepository) : super(MarketsInitial());

  void loadMarkets() {
    marketsRepository.getAllMarkets().then((markets) {
      emit(MarketsLoaded(markets));
    });
  }
}
