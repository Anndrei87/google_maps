import 'package:flutter/material.dart';
import 'package:maps_live/src/pages/order_tracking_page.dart';
import 'package:maps_live/src/providers/maps_controller.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider(
        create: (_) => MapProvider(),
        child: const MapPage(),
      ),
    );
  }
}
