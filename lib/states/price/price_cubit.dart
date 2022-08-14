import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:deriv_flutter_task/data/streams/price_stream.dart';

part 'price_state.dart';

class PriceCubit extends Cubit<PriceState> {
  final PriceStream priceStream;

  PriceCubit(this.priceStream) : super(PriceInitial());

  void loadPriceStream(String symbol) {
    emit(LoadingPriceStream());
    priceStream.getPriceStream(symbol).listen((value) {
      if (value is double) {
        emit(PriceUpdated(value));
      } else {
        emit(MarketIsClosed(value));
      }
    });
  }
}
