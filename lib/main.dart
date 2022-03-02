import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Matrix',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: Splash(),
    );
  }
}