import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;


DataColumn setDataColumn(double cwidth,String ctext){
  return DataColumn(
      label: Container(
        width: cwidth,
        child: Text(ctext)
      ),
  );
}

List<DataColumn> headDataColumns(List<dynamic> json){
  List<DataColumn> listReturn = <DataColumn> [];
  for (var i in json){
    listReturn.add(setDataColumn(30,i));
  }
  return listReturn;
}

List<DataRow> rowDataColumns (List json,List<dynamic> jsonHeaders){
  List<DataRow> rowsReturn = <DataRow> [];
  for (Map i in json){
    rowsReturn.add(
      DataRow(
        cells: rowDataCells(i,jsonHeaders),
      )
    );
    
  }
  return rowsReturn;

}

List<DataCell> rowDataCells (Map<String,dynamic> json,List<dynamic> jsonHeaders){
  List<DataCell> cells = <DataCell> [];
  // implement for loop to increase cells.
  for (var i in jsonHeaders){
    cells.add(DataCell(Text(json[i].toString())));
  }
  return cells;
}






Widget restTable(String link){
  return FutureBuilder(
      future: http.get(link),
      builder: (context,snapshot){
        if (snapshot.hasData){
          final jsonBody = json.decode(snapshot.data.body); 
          return DataTable(
            sortColumnIndex: 0,
            sortAscending: true,
            columns: headDataColumns(jsonBody['columns']),
            rows: rowDataColumns(jsonBody['data'],jsonBody['columns']),
            
          );
          
           
        }
        else{
          return CircularProgressIndicator();
        }

        }
      );
      
  
	}










