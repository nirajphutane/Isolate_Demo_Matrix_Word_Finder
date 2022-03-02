import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'package:flutter/material.dart';
import 'matrix.dart';
import 'matrix_input.dart';

class MatrixSize extends StatefulWidget {

  @override
  _MatrixSizeState createState() => _MatrixSizeState();
}

class _MatrixSizeState extends State<MatrixSize> {

  int row, column;
  bool isLoading = false;
  String alphabet;
  double percentage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Matrix Size', style: TextStyle(color: Colors.yellowAccent)),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 5),

              TextField(
                keyboardType: TextInputType.number,
                onChanged: (text){
                  row = int.parse(text?? 0);
                },
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  fillColor: Colors.indigo.shade100,
                  border: OutlineInputBorder(),
                  labelText: 'Row',
                  hintText: 'm',
                  prefixIcon: Icon(Icons.table_rows_outlined, color: Colors.indigoAccent),
                  suffixIcon: Icon(Icons.grid_on, color: Colors.indigoAccent),
                ),
              ),

              SizedBox(height: 5),

              TextField(
                keyboardType: TextInputType.number,
                onChanged: (text){
                  column = int.parse(text?? 0);
                },
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  fillColor: Colors.indigo.shade100,
                  border: OutlineInputBorder(),
                  labelText: 'Column',
                  hintText: 'n',
                  prefixIcon: RotatedBox(
                    quarterTurns: 1,
                    child: Icon(Icons.table_rows_outlined, color: Colors.indigoAccent),
                  ),
                  suffixIcon: Icon(Icons.grid_on, color: Colors.indigoAccent),
                ),
              ),

              SizedBox(height: 15),

              ElevatedButton.icon(
                icon: Icon(
                  Icons.grid_on,
                  color: Colors.yellowAccent,
                  size: 24.0,
                ),
                label: Text('Create Matrix'),
                onPressed: () {
                  if(row == null || column == null || row <= 0 || column <= 0){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration: Duration(seconds: 5), content: Text('Enter Row and Column for m * n matrix.')));
                    return;
                  }
                  if(column > 12){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration: Duration(seconds: 5), content: Text('Column (n) of matrix should not be greater than 12 due to UI limitations')));
                    return;
                  }
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MatrixInput(row: row, column: column)));
                },
              ),

              SizedBox(height: 5),

              ElevatedButton.icon(
                icon: Icon(
                  Icons.grid_on_sharp,
                  color: Colors.yellowAccent,
                  size: 24.0,
                ),
                label: Text('Create Random Matrix'),
                onPressed: () async {
                  if(row == null || column == null || row <= 0 || column <= 0){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration: Duration(seconds: 5), content: Text('Enter Row and Column for m * n matrix.')));
                    return;
                  }
                  FocusScope.of(context).requestFocus(FocusNode());
                  createMatrix();
                },
              )
            ],
          ),
          isLoading? AbsorbPointer(
            absorbing: true,
            child: Container(
              alignment: Alignment.center,
              child: Card(
                child: Container(
                  width: MediaQuery.of(context).size.width/3,
                  height: MediaQuery.of(context).size.height/4.5,
                  color: Colors.indigo,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Isolate', style: TextStyle(color: Colors.yellow, fontSize: 12)),
                      SizedBox(height: 10),
                      CircularProgressIndicator(
                        value: percentage?? 0,
                        backgroundColor: Colors.indigo,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.yellowAccent),
                      ),
                      Text('${((percentage?? 0) * 100).toInt()}%', style: TextStyle(color: Colors.yellowAccent, fontSize: 20)),
                      SizedBox(height: 2),
                      Text(alphabet?? '', style: TextStyle(color: Colors.yellowAccent, fontSize: 40)),
                      SizedBox(height: 5),
                      Text('Creating Matrix', style: TextStyle(color: Colors.yellowAccent, fontSize: 10)),
                    ],
                  ),
                ),
              ),
            ),
          ): Container(),
        ],
      ),
    );
  }

  Future<void> createMatrix() async {
    List<String> alphabets = [];
    Completer completer = Completer<SendPort>();
    ReceivePort fromIsolate = ReceivePort();
    Isolate isolate = await Isolate.spawn(createMatrixElements, fromIsolate.sendPort);
    fromIsolate.listen((data) async {
      if (data is SendPort) {
        completer.complete(data);
      } else {
        if(data == true){
          setState(() { isLoading = data; });
        } else if(data == false){
          setState(() { isLoading = data; });
          isolate.kill();
          fromIsolate.close();
          Navigator.push(context, MaterialPageRoute(builder: (context) => AlphabetMatrix(row: row, column: column, alphabets: alphabets)));
        } else {
          setState(() {
            alphabet = data[0];
            percentage = data[1];
          });
          alphabets.add(alphabet);
        }
      }
    });
    SendPort toIsolate = await completer.future;
    toIsolate.send([row, column]);
  }
}

createMatrixElements(SendPort sendPort) async {
  ReceivePort receiverPort = ReceivePort();
  sendPort.send(receiverPort.sendPort);
  sendPort.send(true);
  List<int> dimensions = await receiverPort.first;
  Random random = Random();

  int count = 0, total = dimensions[0] * dimensions[1];
  for(int r = 1; r <= dimensions[0]; r++){
    for(int c = 0; c < dimensions[1]; c++){
      sleep(Duration(milliseconds: 1));
      sendPort.send([String.fromCharCodes(List.generate(1, (index)=> random.nextInt(25) + 65)), (count++ / total)]);
    }
  }
  sendPort.send(false);
}
