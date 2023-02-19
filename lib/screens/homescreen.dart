import 'dart:io';

import 'package:band_nameapp/models/models.dart';
import 'package:band_nameapp/services/socket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Band> bands = [
    // Band(id: '1', name: 'banda 1', vote: 0),
    // Band(id: '2', name: 'Metallica ', vote: 1),
    // Band(id: '3', name: 'Caramelo de Cianuro ', vote: 3),
    // Band(id: '4', name: 'Linkin Park', vote: 10),
  ];
  @override
  void initState() {
    final socketServer = Provider.of<SocketService>(context, listen: false);
    socketServer.socket.on('bandas-act', _handleActiveBands);

    // print(data);
    //   bands = (data as List).map((banda) => Band.fromMap(banda)).toList();
    //   setState(() {});
    // });

    super.initState();
  }

  void _handleActiveBands(dynamic payload) {
    bands = (payload as List).map((banda) => Band.fromMap(banda)).toList();
    setState(() {});
  }

  @override
  void dispose() {
    final socketServer = Provider.of<SocketService>(context, listen: false);
    socketServer.socket.off('bandas-act');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketServer = Provider.of<SocketService>(context);
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Band Raking', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: socketServer.serverStatus == ServerStatus.online
                ? const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  )
                : const Icon(
                    Icons.offline_bolt,
                    color: Colors.red,
                  ),
          )
        ],
      ),
      body: Column(
        children: [
          _showGraph(),
          SizedBox(
            width: double.infinity,
            height: 300,
            child: ListView.builder(
                itemCount: bands.length,
                itemBuilder: (_, index) => bandTitle(bands[index])),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addNewBand(true, null),
        elevation: 0,
        child: const Icon(Icons.add_circle_outline),
      ),
    );
  }

  Widget bandTitle(Band banda) {
    final socketServer = Provider.of<SocketService>(context, listen: false);
    return Dismissible(
      key: Key(banda.id!),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          return true; // Confirma el despido y activa la animación
        } else {
          addNewBand(false, banda);

          return false; // Desactiva la animación
        }
      },
      onUpdate: (details) {
        if (details.direction == DismissDirection.startToEnd) {
          // El elemento se está moviendo hacia la derecha
          if (!socketServer.disstend) {
            socketServer.disstend = true;
          }
          print('Comenzó a moverse hacia la dirección startToEnd');
        } else {
          if (socketServer.disstend) {
            socketServer.disstend = false;
          }
          print('END to Start Comenzó a moverse hacia la dirección startToEnd');
        }
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          socketServer.socket.emit('delete-banda', {'id': banda.id});
        } else {
          print('End to Star');
          // addNewBand(false, banda);
          // socketServer.socket.emit('update-banda', {
          //   'id': banda.id,
          //   'name': socketServer.upname,
          //   'votes': banda.votes
          // });
        }
      },
      background: Container(
        padding: const EdgeInsets.only(left: 15),
        color: socketServer.disstend ? Colors.red : Colors.green,
        // decoration: const BoxDecoration(
        //     gradient: LinearGradient(
        //         colors: [Colors.red, Colors.green],
        //         begin: Alignment.centerLeft,
        //         end: Alignment.centerRight,
        //         stops: [0.5, 0.5])),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              socketServer.disstend
                  ? const Icon(
                      Icons.delete_forever,
                      color: Colors.white,
                    )
                  : const SizedBox(
                      width: 10,
                    ),
              const SizedBox(
                width: 180,
              ),
              socketServer.disstend
                  ? const SizedBox(
                      width: 10,
                    )
                  : const Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
            ],
          ),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(banda.name!.substring(0, 2)),
        ),
        title: Text(banda.name!),
        trailing: Text('${banda.votes}'),
        onTap: () {
          // addNewBand(false, banda);
          socketServer.socket.emit('vote-bans', {'id': banda.id});
          //  banda.id
        },
      ),
    );
  }

  void addNewBand(bool isnew, Band? banda) {
    final textController = TextEditingController();
    final socketServer = Provider.of<SocketService>(context, listen: false);
    if (!Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (context) {
          if (isnew) {
            textController.text = banda!.name!;
          }
          return AlertDialog(
            title: isnew
                ? const Text('New band name:')
                : const Text('UpLoad Name:'),
            content: TextField(
              controller: textController,
            ),
            actions: [
              MaterialButton(
                  textColor: Colors.blue,
                  onPressed: () {
                    if (isnew) {
                      addBandToList(textController.text);
                    } else {
                      if (textController.text.length > 2) {
                        socketServer.socket.emit('update-banda', {
                          'id': banda!.id,
                          'name': textController.text,
                          'votes': banda.votes
                        });

                        Navigator.pop(context);
                      }
                    }
                  },
                  child: isnew ? const Text('Add') : const Text('ok'))
            ],
          );
        },
      );
    } else {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: isnew
                ? const Text('New band name:')
                : const Text('UpLoad Name:'),
            content: CupertinoTextField(controller: textController),
            actions: [
              CupertinoDialogAction(
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              CupertinoDialogAction(
                child: isnew ? const Text('Add') : const Text('ok'),
                onPressed: () {
                  if (isnew) {
                    addBandToList(textController.text);
                  } else {
                    if (textController.text.length > 2) {
                      socketServer.socket.emit('update-banda', {
                        'id': banda!.id,
                        'name': textController.text,
                        'votes': banda.votes
                      });

                      Navigator.pop(context);
                    }
                  }
                },
              )
            ],
          );
        },
      );
    }
  }

  void addBandToList(String name) {
    if (name.isNotEmpty) {
      //bands.add(Band(id: DateTime.now().toString(), name: name, votes: 0));
      final socketServer = Provider.of<SocketService>(context, listen: false);
      socketServer.socket.emit('add-band', {'name': name});
      setState(() {});
    }
    Navigator.pop(context);
  }

  Widget _showGraph() {
    Map<String, double> dataMap = {};
    for (var element in bands) {
      dataMap.putIfAbsent(element.name!, () => element.votes!.toDouble());
    }
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: PieChart(
        dataMap: dataMap.isEmpty ? {'No Data': 0} : dataMap,
        animationDuration: const Duration(milliseconds: 800),
        chartLegendSpacing: 32,
        chartRadius: MediaQuery.of(context).size.width / 3.2,
        colorList: const [
          Color.fromARGB(255, 76, 175, 80),
          Color.fromARGB(255, 34, 153, 250),
          Color.fromARGB(255, 156, 39, 176),
          Color.fromARGB(255, 33, 150, 243),
          Color.fromARGB(255, 156, 39, 176),
          Color.fromARGB(255, 244, 67, 54),
          Color.fromARGB(255, 255, 235, 59),
          Color.fromARGB(255, 244, 67, 54),
          Color.fromARGB(255, 255, 235, 59),
          Color.fromARGB(255, 76, 175, 80),
        ],
        initialAngleInDegree: 0,
        chartType: ChartType.ring,
        ringStrokeWidth: 32,
        centerText: "BANDS",
        legendOptions: const LegendOptions(
          showLegendsInRow: false,
          legendPosition: LegendPosition.right,
          showLegends: true,
          legendShape: BoxShape.circle,
        ),
        chartValuesOptions: const ChartValuesOptions(
          showChartValueBackground: true,
          showChartValues: true,
          showChartValuesInPercentage: false,
          showChartValuesOutside: false,
          decimalPlaces: 1,
        ),
      ),
    );
  }
}
