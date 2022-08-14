import 'dart:convert';
import 'dart:developer';

import 'package:web_socket_channel/web_socket_channel.dart';

class ApiService {
  final Uri _uri = Uri.parse('wss://ws.binaryws.com/websockets/v3?app_id=1089');
  final JsonEncoder _jsonEncoder = const JsonEncoder();

  WebSocketChannel getActiveSymbolsChannel() {
    final WebSocketChannel channel = WebSocketChannel.connect(_uri);

    channel.sink.add(_jsonEncoder
        .convert({'active_symbols': 'brief', 'product_type': 'basic'}));

    return channel;
  }

  WebSocketChannel getTicksChannel(String symbol) {
    final WebSocketChannel channel = WebSocketChannel.connect(_uri);

    channel.sink.add(_jsonEncoder.convert({'ticks': symbol, 'subscribe': 1}));

    return channel;
  }

  void cancelStream(String id) {
    final WebSocketChannel channel = WebSocketChannel.connect(_uri);
    channel.sink.add(_jsonEncoder.convert({'forget': id}));
    channel.sink.close();
  }
}
