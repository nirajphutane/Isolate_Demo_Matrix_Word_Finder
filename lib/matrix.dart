import 'dart:async';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isoates_demo/matrix_search.dart';

class AlphabetMatrix extends StatefulWidget {

  final int row, column;
  final List<String> alphabets;
  AlphabetMatrix({@required this.row, @required this.column, @required this.alphabets}):
        assert(row != null, 'Row should not be null'),
        assert(column != null, 'Column should not be null'),
        assert(alphabets != null && alphabets.isNotEmpty, 'Alphabets should not be null or empty');

  @override
  _AlphabetMatrixState createState() => _AlphabetMatrixState();
}

class _AlphabetMatrixState extends State<AlphabetMatrix> {

  List<List<String>> matrix;
  List<int> highlightIndex = [];

  @override
  void initState() {
    matrix = toMatrix();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search in Matrix of ${widget.row} * ${widget.column}', style: TextStyle(color: Colors.yellowAccent)),
      ),
      body: Column(
        children: [
          SizedBox(height: 5),
          TextField(
            onChanged: (text){
              setState(() {
                highlightIndex = [];
              });
              search(text);
            },
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: Colors.indigo.shade100,
              border: OutlineInputBorder(),
              labelText: 'Search',
              hintText: 'ABCD...',
              prefixIcon: Icon(Icons.search_outlined, size: 25, color: Colors.indigoAccent),
              suffixIcon: Icon(Icons.grid_on, color: Colors.indigoAccent),
            ),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp('[A-Z]')),
            ],
            textCapitalization: TextCapitalization.characters,
            keyboardType: TextInputType.name,
          ),

          SizedBox(height: 5),

          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.column,
              ),
              itemCount: widget.alphabets.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  color: Colors.white,
                  child: Center(
                    child: Text('${widget.alphabets[index]}', style: TextStyle(color: highlightIndex.contains(index)? Colors.redAccent: Colors.indigoAccent, fontSize: 20)),
                  ),
                );
              }
            ),
          ),
        ],
      ),
    );
  }

  void search(String word) async {
    if(word == null){
      return;
    }
    searchHorizontal(word.split(''));
    searchVertical(word.split(''));
    searchDiagonal(word.split(''));
  }

  searchHorizontal(List<String> alphabets) async {
    Completer completer = Completer<SendPort>();
    ReceivePort fromIsolate = ReceivePort();
    Isolate isolate = await Isolate.spawn(MatrixSearch.horizontalSearch, fromIsolate.sendPort);
    fromIsolate.listen((data) async {
      if (data is SendPort) {
        completer.complete(data);
      } else {
        setState(() {
          highlightIndex.add(data);
          print('HR: $highlightIndex');
        });
      }
    });
    SendPort toIsolate = await completer.future;
    toIsolate.send([widget.row, widget.column, matrix, alphabets]);
  }

  searchVertical(List<String> alphabets) async {
    Completer completer = Completer<SendPort>();
    ReceivePort fromIsolate = ReceivePort();
    Isolate isolate = await Isolate.spawn(MatrixSearch.verticalSearch, fromIsolate.sendPort);
    fromIsolate.listen((data) async {
      if (data is SendPort) {
        completer.complete(data);
      } else {
        setState(() {
          highlightIndex.add(data);
          print('VR: $highlightIndex');
        });
      }
    });
    SendPort toIsolate = await completer.future;
    toIsolate.send([widget.row, widget.column, matrix, alphabets]);
  }

  searchDiagonal(List<String> alphabets) async {
    Completer completer = Completer<SendPort>();
    ReceivePort fromIsolate = ReceivePort();
    Isolate isolate = await Isolate.spawn(MatrixSearch.diagonalSearch, fromIsolate.sendPort);
    fromIsolate.listen((data) async {
      if (data is SendPort) {
        completer.complete(data);
      } else {
        setState(() {
          highlightIndex.add(data);
          print('DI: $highlightIndex');
        });
      }
    });
    SendPort toIsolate = await completer.future;
    toIsolate.send([widget.row, widget.column, matrix, alphabets]);
  }

  List<List<String>> toMatrix() {
    List<List<String>> matrix = [];
    List<String> temp = List.from(widget.alphabets);
    for(int c = 0; c < widget.row; c++){
      matrix.add(List.from(temp.sublist(0, widget.column)));
      temp.removeRange(0, widget.column);
    }
    return matrix;
  }
}
