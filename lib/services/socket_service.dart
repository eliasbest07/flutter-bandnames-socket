import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { online, offline, connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.connecting;
  late IO.Socket _socket;
  bool _disstend = false;
  bool get disstend => _disstend;
  void set disstend(bool starttoend) {
    _disstend = starttoend;
    notifyListeners();
  }

  SocketService() {
    _initConfig();
  }
  ServerStatus get serverStatus => _serverStatus;
  IO.Socket get socket => _socket;
  Function get emit => _socket.emit;
  void _initConfig() {
    _socket = IO.io('http://192.168.1.103:3000/', {
      'transports': ['websocket'],
      'autoConnect': true
    });
    _socket.onConnect((_) {
      print('connect');
      _serverStatus = ServerStatus.online;
      notifyListeners();
      _socket.emit('msg', 'test');
    });
    _socket.on('event', (data) => print(data));
    _socket.onDisconnect((_) {
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });
    _socket.on('fromServer', (_) => print('$_ from server'));

    _socket.on('nuevo-mensaje', (payload) {
      print(
          'Nuevo mensaje De ${payload['nombre']} y dice ${payload['mensaje']}');
    });
  }
}
