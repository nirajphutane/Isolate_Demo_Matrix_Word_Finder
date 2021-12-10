import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'matrix.dart';

class MatrixInput extends StatefulWidget {

  final int row, column;
  MatrixInput({@required this.row, @required this.column}):
    assert(row != null, 'Row should not be null'),
    assert(column != null, 'Column should not be null');

  @override
  _MatrixInputState createState() => _MatrixInputState();
}

class _MatrixInputState extends State<MatrixInput> {

  int count = 0, row = 0, column = 0;
  TextEditingController editingController = TextEditingController();
  List<String> alphabets = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Matrix of ${widget.row} * ${widget.column}', style: TextStyle(color: Colors.yellowAccent)),
      ),
      body: Column(
        children: [
          SizedBox(height: 15),

          RichText(
            text: TextSpan(
              text: 'Enter Alphabet at ',
              style: TextStyle(color: Colors.indigoAccent, fontSize: 20),
              children: <TextSpan>[
                TextSpan(text: 'M [$row] [$column]', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
              ],
            ),
          ),

          SizedBox(height: 15),

          TextField(
            controller: editingController,
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: Colors.indigo.shade100,
              border: OutlineInputBorder(),
              labelText: 'Alphabet',
              hintText: 'A, B, C ... Y, Z',
              prefixIcon: Icon(Icons.sort_by_alpha, color: Colors.indigoAccent),
              suffixIcon: Icon(Icons.grid_on, color: Colors.indigoAccent),
            ),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'^[A-Z]{1}')),
            ],
            textCapitalization: TextCapitalization.characters,
            keyboardType: TextInputType.name,
          ),

          SizedBox(height: 15),

          ElevatedButton.icon(
            icon: Icon(
              Icons.add,
              color: Colors.yellowAccent,
              size: 24.0,
            ),
            label: Text('Add To Matrix'),
            onPressed: () {
              if(editingController.text == ''){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration: Duration(seconds: 5), content: Text('Enter Alphabet!')));
                return;
              }

              count++;
              if(column == widget.column-1){
                row++;
                column = -1;
              } column++;

              alphabets.add(editingController.text);

              if(count < widget.row * widget.column){
                editingController.text = '';
                setState(() { });
                return;
              }
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AlphabetMatrix(row: widget.row, column: widget.column, alphabets: alphabets)));
            },
          ),
        ],
      ),
    );
  }
}
