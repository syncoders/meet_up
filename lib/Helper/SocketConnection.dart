import 'dart:convert';

import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:adhara_socket_io/manager.dart';
import 'package:adhara_socket_io/options.dart';
import './Constant.dart';
import 'package:flutter/services.dart';

typedef void OnMessageCallback(dynamic msg);
typedef void OnCloseCallback(int code, String reason);
typedef void OnOpenCallback();

class SocketManager {
  // static final SocketManager _singleton = SocketManager._internal();

  // factory SocketManager() {
  //   return _singleton;
  // }

  // SocketManager._internal();
  SocketIOManager manager;
  SocketIO socket;
  OnOpenCallback onOpen;
  OnMessageCallback onMessage;
  OnMessageCallback onReceivedData;
  OnCloseCallback onClose;
//https://callcafe.in:9000/
// https://callcafe.in:8082/
  initSocket() async {
    manager = SocketIOManager();
    socket = await manager.createInstance(SocketOptions(SIGNALING.serverURL));
    socket.onConnect((data) {
      pprint("connected... from the socket manager class");
      pprint(data);
      // this?.onMessage('Connected');
      this?.onOpen();
    });
    socket.onConnectError(pprint);
    socket.onConnectTimeout(pprint);
    socket.onError(pprint);
    socket.onDisconnect(pprint);
    socket.on("message", (data) {
      pprint('Data has been Received from server from the manager class:$data');
      if (data != null) {
        JsonEncoder encoder = new JsonEncoder();
        onMessage?.call(encoder.convert(data));
      }

      // Signaling('').receivedMessage(data);
    });
    socket.onConnect((data) {
      print(data);
      if (data != null) {
        onMessage?.call('Connected');
      }
    });
    socket.connect();
  }

  //try to check for speaker Mode
  static const MethodChannel _channel =
      const MethodChannel('cloudwebrtc.com/incall.manager');

  Future<void> setSpeakerphoneOn(enable) async {
    try {
      await _channel.invokeMethod(
          'setSpeakerphoneOn', <String, dynamic>{'enable': enable});
    } on PlatformException catch (e) {
      throw 'Unable to setSpeakerphoneOn: ${e.message}';
    }
  }

  disconnect() {
    manager.clearInstance(socket);
    this.socket.isConnected().then((value) {
      print('Socket status after disconnect:$value');
    });
  }

  send(event, data) {
    data['type'] = event;
    JsonEncoder encoder = new JsonEncoder();
    socket.emit('message', [encoder.convert(data)]);
  }

  sendTest(event, data) {
    data['type'] = event;
    JsonEncoder encoder = new JsonEncoder();
    socket.emit('test', [encoder.convert(data)]);
  }

  pprint(data) {
    print(data);
  }
}
