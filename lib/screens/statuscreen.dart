import 'package:band_nameapp/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    //socketService.socket.emit();
    return Scaffold(
      body: Center(
        child: Text('StatusScreen: ${socketService.serverStatus} '),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('se emite');
          socketService.socket.emit('emitir-nuevo-mensaje',
              {'nombre': 'Flutter', 'mensaje': ' hola desde Flutter'});
          // socketService.emit('emitir-nuevo-mensaje',
          // {'nombre': 'Flutter', 'mensaje': ' hola desde Flutter'});
        },
        child: const Icon(Icons.message),
      ),
    );
  }
}
