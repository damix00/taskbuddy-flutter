
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:taskbuddy/api/options.dart';
import 'package:taskbuddy/cache/account_cache.dart';

class SocketListener {
  final String eventName;
  final Function(String) callback;

  SocketListener(this.eventName, this.callback);
}

class SocketClient {
  static List<SocketListener> _listeners = [];

  static final IO.Socket socket = IO.io(
    ApiOptions.baseUrl,
    IO.OptionBuilder()
      .setTransports(['websocket'])
      .enableReconnection()
      .setReconnectionAttempts(1e5) // Really high number
      .disableAutoConnect()
      .build()
  );

  static Future<void> connect() async {
    print("Connecting to socket...");
    String token = (await AccountCache.getToken())!;

    socket.io.options?['extraHeaders'] = {
      'Authorization': 'Bearer $token'
    };

    socket.connect();

    socket.onAny((event, data) {
      print('Socket event: $event');
      print('Socket data: $data');
      _listeners.forEach((listener) {
        if (event == listener.eventName) {
          listener.callback(data);
        }
      });
    });
  }

  static void addListener(String eventName, Function(String) callback) {
    _listeners.add(SocketListener(eventName, callback));
  }
  
  static void disposeListener(String eventName, Function(String) callback) {
    _listeners.removeWhere((listener) => listener.eventName == eventName && listener.callback == callback);
  }
}