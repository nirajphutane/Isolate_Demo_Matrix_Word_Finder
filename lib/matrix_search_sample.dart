import 'dart:io';
import 'package:collection/collection.dart';

List<List<String>> matrix;
int noRow, noColumn;

main(){

  // matrix = [
  //   ['A', 'B', 'C'],
  //   ['D', 'E', 'F'],
  //   ['G', 'K', 'I'],
  // ];

  // matrix = [
  //   ['A', 'B', 'C', 'D'],
  //   ['E', 'F', 'G', 'H'],
  //   ['I', 'J', 'K', 'L'],
  //   ['M', 'N', 'O', 'P'],
  // ];

  matrix = [
    ['A', 'B', 'C', 'D'],
    ['E', 'F', 'G', 'H'],
    ['I', 'J', 'K', 'L'],
  ];

  // matrix = [
  //   ['A', 'B', 'C',],
  //   ['D', 'E', 'F',],
  //   ['G', 'H', 'I',],
  //   ['J', 'K', 'L',],
  // ];

  noRow = matrix.length;
  noColumn = matrix[0].length;

  print('Row:- $noRow');
  print('Column:- $noColumn');

  String word = 'BGL';
  search(word);
}

void search(String word){
  if(word == null){
    return;
  }
  print('Word:- $word');
  List<String> alphabets = word.split('');

  // List<List> hrSearchResults = horizontalSearch(alphabets);
  // List<List> vrSearchResults = verticalSearch(alphabets);
  List<List> diSearch = diagonalSearch(alphabets);

  // findLinearIndex(hrSearchResults);
  // findLinearIndex(vrSearchResults);
  findLinearIndex(diSearch);
}

horizontalSearch(List<String> alphabets){
  print('Horizontal Search:-');
  List<List> hrSearchResults = [];

  List<List> elements = [];
  for(int r = 0; r < matrix.length; r++){
    for(int c = 0; c < matrix[r].length; c++){
      stdout.write('${matrix[r][c]} ');
      elements.add([matrix[r][c], r, c]);
    }
    print('');
  }
  print('Elements in 1D: $elements');

  List<List> matrix2D = [];
  int offset = 0, limit;
  if(noRow > noColumn){
    limit = noRow < noColumn? noRow: noColumn;
  } else {
    limit = noRow > noColumn? noRow: noColumn;
  }
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
        hrSearchResults.add(row);
      }
    }
  }
  print('Horizontal Matches:- $hrSearchResults');
  return hrSearchResults;
}

verticalSearch(List<String> alphabets){
  print('Vertical Search:-');
  List<List> vrSearchResults = [];

  List<List> elements = [];
  for(int c = 0; c < noColumn; c++){
    for(int r = 0; r < noRow; r++){
      stdout.write('${matrix[r][c]} ');
      elements.add([matrix[r][c], r, c]);
    }
    print('');
  }
  print('Elements in 1D: $elements');

  List<List> matrix2D = [];
  int offset = 0, limit;
  if(noRow < noColumn){
    limit = noRow < noColumn? noRow: noColumn;
  } else {
    limit = noRow > noColumn? noRow: noColumn;
  }
  for(int i = 0; i < elements.length/limit; i++){
    matrix2D.add(elements.sublist(offset, offset+limit));
    offset = offset + limit;
  }
  print('Elements in 2D: $matrix2D');

  for(List column in matrix2D){
    List<List> subColumn = [];
    for(int i = 0; i < (limit-alphabets.length)+1; i++){
      subColumn.add(column.sublist(i, alphabets.length+i));
    }
    for(List row in subColumn){
      List<String> items = [];
      for(List list in row){
        items.add(list[0]);
      }
      if(IterableEquality().equals(items, alphabets)){
        vrSearchResults.add(row);
      }
    }
  }
  print('Vertical Matches:- $vrSearchResults');
  return vrSearchResults;
}

List<List> diagonalSearch(List<String> alphabets){
  for(int r = 0; r < matrix.length; r++){
    for(int c = 0; c < matrix[r].length; c++){
      stdout.write('${matrix[r][c]} ');
    }
    print('');
  }

  print('Diagonal Search:-');
  List<List> diSearchResults = [];

  List<List> matrix2D = [];
  int limit = noRow > noColumn? noRow: noColumn;
  for(int r = 0; r < matrix[0].length-1; r++){
    int c = r;
    List items = [];
    for(int i = 0; i < limit; i++){
      try{
        print('R:->: ${matrix[i][c]} $i $c');
        items.add([matrix[i][c], i, c]);
      } catch(e){ }
      c++;
    }
    matrix2D.add(items);
    limit--;
  }

  limit = noRow > noColumn? noRow: noColumn;
  for(int c = 0; c < matrix.length-1; c++){
    int r = c;
    List items = [];
    for(int i = 0; i < limit; i++){
      try{
        print('C:->: ${matrix[r][i]} $r $i');
        items.add([matrix[r][i], r, i]);
      } catch(e){ }
      r++;
    }
    matrix2D.add(items);
    limit--;
  }

  print('Elements in 2D: $matrix2D');

  for(List row in matrix2D) {
    // print('Di:- $row');
    List<List> subRow = [];
    for(int i = 0; i < row.length; i++){
      try{
        subRow.add(row.sublist(i, alphabets.length+i));
      } catch(e){ }
    }
    // print('SubRow:- $subRow');
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

findLinearIndex(List<List> list){
  print('FindIndex:- ');
  for(List pkg in list){
    for(pkg in pkg){
      print('Index:- ${getIndex(pkg[1], pkg[2])}');
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