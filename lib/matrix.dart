import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  void search(String word){
    if(word == null){
      return;
    }
    List<String> alphabets = word.split('');

    List<List> hrSearchResults = horizontalSearch(alphabets);
    List<List> vrSearchResults = verticalSearch(alphabets);
    List<List> diSearchResults = diagonalSearch(alphabets);
    findLinearIndex(hrSearchResults).listen((event) {
      setState(() {
        highlightIndex.add(event);
        print('HR: $highlightIndex');
      });
    });
    findLinearIndex(vrSearchResults).listen((event) {
      setState(() {
        highlightIndex.add(event);
        print('VR: $highlightIndex');
      });
    });
    findLinearIndex(diSearchResults).listen((event) {
      setState(() {
        highlightIndex.add(event);
        print('DI: $highlightIndex');
      });
    });
  }

  horizontalSearch(List<String> alphabets){
    print('Horizontal Search:-');

    List<List> elements = [];
    /*Right ---> Left*/
    for(int r = 0; r < matrix.length; r++){
      for(int c = 0; c < matrix[r].length; c++){
        elements.add([matrix[r][c], r, c]);
      }
    }

    /*Left ---> Right*/
    // for(int r = matrix.length-1; r >= 0; r--){
    //   for(int c = matrix[r].length-1; c >= 0 ; c--){
    //     elements.add([matrix[r][c], r, c]);
    //   }
    // }
    print('Elements in 1D: $elements');
    
    int limit;
    if(widget.row > widget.column){
      limit = widget.row < widget.column? widget.row: widget.column;
    } else {
      limit = widget.row > widget.column? widget.row: widget.column;
    }

    List<List> hrSearchResults = rowColumnSearch(alphabets, elements, limit);
    print('Horizontal Matches:- $hrSearchResults');
    return hrSearchResults;
  }

  verticalSearch(List<String> alphabets){
    print('Vertical Search:-');

    List<List> elements = [];
    /*Top --> Bottom*/
    for(int r = 0; r < matrix[0].length; r++){
      for(int c = 0; c < matrix.length; c++){
        elements.add([matrix[c][r], c, r]);
      }
    }
    // /*Bottom --> Top*/
    // for(int r = matrix[0].length-1; r >= 0; r--){
    //   for(int c = matrix.length-1; c >= 0; c--){
    //     elements.add([matrix[c][r], c, r]);
    //   }
    // }
    print('Elements in 1D: $elements');

    int limit;
    if(widget.row < widget.column){
      limit = widget.row < widget.column? widget.row: widget.column;
    } else {
      limit = widget.row > widget.column? widget.row: widget.column;
    }
    
    List<List> vrSearchResults = rowColumnSearch(alphabets, elements, limit);
    print('Vertical Matches:- $vrSearchResults');
    return vrSearchResults;
  }

  List<List> rowColumnSearch(List<String> alphabets, List<List> elements, int limit){
    List<List> matrix2D = [], matches = [];
    int offset = 0;
    for(int i = 0; i < elements.length/limit; i++){
      matrix2D.add(elements.sublist(offset, offset+limit));
      offset = offset + limit;
    }
    print('Elements in 2D: $matrix2D');

    for(List row in matrix2D){
      List<List> subRow = [];
      for(int i = 0; i < (limit-alphabets.length)+1; i++){
        subRow.add(row.sublist(i, alphabets.length+i));
      }
      for(List row in subRow){
        List<String> items = [];
        for(List list in row){
          items.add(list[0]);
        }
        if(IterableEquality().equals(items, alphabets)){
          matches.add(row);
        }
      }
    }
    return matches;
  }

  List<List> diagonalSearch(List<String> alphabets){
    print('Diagonal Search:-');
    List<List> diSearchResults = [];

    List<List> matrix2D = [];
    int limit = widget.row > widget.column? widget.row: widget.column;
    for(int r = 0; r < matrix[0].length-1; r++){
      int c = r;
      List items = [];
      for(int i = 0; i < limit; i++){
        try{
          items.add([matrix[i][c], i, c]);
        } catch(e){ }
        c++;
      }
      matrix2D.add(items);
      limit--;
    }

    limit = widget.row > widget.column? widget.row: widget.column;
    for(int c = 0; c < matrix.length-1; c++){
      int r = c;
      List items = [];
      for(int i = 0; i < limit; i++){
        try{
          items.add([matrix[r][i], r, i]);
        } catch(e){ }
        r++;
      }
      matrix2D.add(items);
      limit--;
    }
    
    print('Elements in 2D: $matrix2D');

    for(List row in matrix2D) {
      List<List> subRow = [];
      for(int i = 0; i < row.length; i++){
        try{
          subRow.add(row.sublist(i, alphabets.length+i));
        } catch(e){ }
      }
      for(List row in subRow){
        List<String> items = [];
        for(List list in row){
          items.add(list[0]);
        }
        if(IterableEquality().equals(items, alphabets)){
          diSearchResults.add(row);
        }
      }
    }
    print('Diagonal Matches:- $diSearchResults');
    return diSearchResults;
  }

  findLinearIndex(List<List> list) async* {
    print('FindIndex:- ');
    for(List pkg in list){
      for(pkg in pkg){
        print('Index:- ${getIndex(pkg[1], pkg[2])}');
        yield getIndex(pkg[1], pkg[2]);
      }
    }
  }

  int getIndex(int row, int column){
    int index = 0;
    for(int r = 0; r < matrix.length; r++){
      for(int c = 0; c < matrix[r].length; c++){
        if(r == row && c == column){
          return index;
        }
        index++;
      }
    }
    return null;
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
