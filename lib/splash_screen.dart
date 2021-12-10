import 'package:flutter/material.dart';
import 'matrix_size.dart';

class Splash extends StatefulWidget {

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2)).then((value) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MatrixSize()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.indigo,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 8,
              child: Center(child: Text('Matrix', style: TextStyle(color: Colors.yellowAccent, fontSize: 72, fontWeight: FontWeight.bold), textAlign: TextAlign.center,))
            ),
            Expanded(child: Text('Made by \n Niraj Phutane', style: TextStyle(color: Colors.yellowAccent, fontSize: 12), textAlign: TextAlign.center,)),
          ],
        ),
      ),
    );
  }
}
