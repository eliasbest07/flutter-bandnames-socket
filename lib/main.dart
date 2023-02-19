import 'package:band_nameapp/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/screens.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => SocketService())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Band Names App ', //Titulo
        initialRoute: 'home', // inicial rutas y screens.dart
        routes: {
          'home': (_) => const HomeScreen(),
          'status': (_) => const StatusScreen(),
        },
      ),
    );
  }
}
