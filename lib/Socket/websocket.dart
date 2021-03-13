import 'package:socket_io_client/socket_io_client.dart' as IO;

typedef void OnMessageCallback(dynamic msg);
typedef void OnCloseCallback(int code, String reason);
typedef void OnOpenCallback();

class SimpleWebSocket {
  String _url;
  IO.Socket _socket;
  OnOpenCallback onOpen;
  OnMessageCallback onMessage;
  OnCloseCallback onClose;
  SimpleWebSocket(this._url);

  connect() async {
    try {
      _socket = IO.io(_url, <String, dynamic>{
        'transports': ['websocket'],
      });
      _socket.on('connect', (_) {
        print('connect Server');
        this?.onOpen();
      });
      _socket.on('event', (data) {
        print(data);
        this?.onMessage(data);
      });
      _socket.on(
        'disconnect',
        (_) => print('disconnect'),
      );
    } catch (e) {
      print("Error : ${e.toString()}");
      this.onClose(500, e.toString());
    }
  }

  send(data) {
    if (_socket != null) {
      _socket.emit("event", data);
      print('send: $data');
    }
  }

  close() {
    _socket.dispose();
  }
}
