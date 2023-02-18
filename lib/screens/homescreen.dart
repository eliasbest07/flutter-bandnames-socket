import 'dart:io';

import 'package:band_nameapp/models/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Band> bands = [
    Band(id: '1', name: 'banda 1', vote: 0),
    Band(id: '2', name: 'Metallica ', vote: 1),
    Band(id: '3', name: 'Caramelo de Cianuro ', vote: 3),
    Band(id: '4', name: 'Linkin Park', vote: 10),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Band Raking', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
          itemCount: bands.length,
          itemBuilder: (_, index) => bandTitle(bands[index])),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewBand,
        elevation: 0,
        child: const Icon(Icons.add_circle_outline),
      ),
    );
  }

  Widget bandTitle(Band banda) {
    return Dismissible(
      key: Key(banda.id!),
      direction: DismissDirection.startToEnd,
      background: Container(
        padding: const EdgeInsets.only(left: 15),
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.delete_forever,
            color: Colors.white,
          ),
        ),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          // TODO backe delete
        }
        print(direction);
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(banda.name!.substring(0, 2)),
        ),
        title: Text(banda.name!),
        trailing: Text('${banda.vote}'),
        onTap: () {},
      ),
    );
  }

  void addNewBand() {
    final textController = TextEditingController();
    if (!Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('New band name:'),
            content: TextField(
              controller: textController,
            ),
            actions: [
              MaterialButton(
                  textColor: Colors.blue,
                  onPressed: () {
                    addBandToList(textController.text);
                  },
                  child: const Text('Add'))
            ],
          );
        },
      );
    } else {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('New Band name:'),
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
                child: const Text('Add'),
                onPressed: () {
                  addBandToList(textController.text);
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
      bands.add(Band(id: DateTime.now().toString(), name: name, vote: 0));
      setState(() {});
    }
    Navigator.pop(context);
  }
}
