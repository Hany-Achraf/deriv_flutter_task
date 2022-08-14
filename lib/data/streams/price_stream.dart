import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:deriv_flutter_task/data/api/api_service.dart';

class PriceStream {
  final ApiService _apiService = ApiService();
  String? _currentSubscriptionId;
  WebSocketChannel? _currentChannel;

  Stream<dynamic> getPriceStream(String symbol) {
    if (_currentChannel != null && _currentSubscriptionId != null) {
      _apiService.cancelStream(_currentSubscriptionId!);
      _currentChannel!.sink.close();
    }

    _currentChannel = _apiService.getTicksChannel(symbol);

    return _currentChannel!.stream.map((tickJson) {
      Map<String, dynamic> tickData = json.decode(tickJson);

      if (tickData.keys.contains('error')) {
        _currentChannel!.sink.close();
        return tickData['error']['message'];
      }

      _currentSubscriptionId = tickData['subscription']['id'];
      return tickData['tick']['ask'];
    });
  }
}
