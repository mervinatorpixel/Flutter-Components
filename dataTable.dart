import 'package:flutter/material.dart';
import 'dart:async';

import 'dart:convert';
import 'package:http/http.dart' as http;



class DataTableClass{
  Function stateSetter;
  String link;
  BuildContext context;
  static bool sort = true;
  List<DataRow> rowDataColumnsFields;
  static int columnIndexnum = 0;

  DataTableClass(this.stateSetter,this.link,this.context);  
  

  List<DataRow> setrowDataColumns (List json,List<dynamic> jsonHeaders){
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






  Widget restTable(){
  
    return FutureBuilder(
        //future: http.get('https://jsonplaceholder.typicode.com/users'),
        future: getFutureData(),
        builder: (context,snapshot){
          if (snapshot.hasData){
            //print(snapshot.data.body);
            //final jsonBody = json.decode(snapshot.data.body); 
            final jsonBody = json.encode({
              "columns" : [
                "Leave Type",
                  "Balance",
                  "Pending",
                  "Entitlement"
              ],

              "data": [
                {
                  "Leave Type": "Xacation",
                  "Balance": 1.21,
                  "Pending": 22,
                  "Entitlement": 33
                },
                {
                  "Leave Type": "Vacation",
                  "Balance": 1.99,
                  "Pending": 23,
                  "Entitlement": 34
                },
                {
                  "Leave Type": "Sick Leave",
                  "Balance": 1.9123,
                  "Pending": 24,
                  "Entitlement": 35
                }
              ]
                
              });
            
 
            rowDataColumns(jsonDecode(jsonBody)['data'],jsonDecode(jsonBody)['columns']);
            return DataTable(
              
              sortColumnIndex: columnIndexnum,
              sortAscending: sort,
              columns: headDataColumns(jsonDecode(jsonBody)['columns'],jsonDecode(jsonBody)['data'],jsonDecode(jsonBody)['columns']),
              rows: rowDataColumnsFields,
              
            );
            
            //return Text(snapshot.data.body);
          }
          else{
            
            return Container(
              width: 40,
              child: CircularProgressIndicator(),
            );
          }

          }
        );
        
  
  }

 
  DataColumn setDataColumn(BuildContext context,double cwidth,String ctext,List json, List<dynamic> jsonHeaders){

    return DataColumn(
        onSort: (columnIndex, ascending){
          sort = !sort;
          setcolumnIndexnum(columnIndex);
          rowDataColumns(json,jsonHeaders);
          stateSetter();
        },
        
        label: Container(
          width: cwidth,
          child: Text(ctext)
        ),
    );
  }


  List<DataColumn> headDataColumns(List<dynamic> json, List json2,List<dynamic> jsonHeaders){
    List<DataColumn> listReturn = <DataColumn> [];
    
    print ((json.elementAt(0)).runtimeType);
    for (var i in json){
      listReturn.add(setDataColumn(context,30,i,json2,jsonHeaders));
    }
    print('worked');
    return listReturn;
  }

  Future<String> getFutureData() async =>
      await Future.delayed(Duration(seconds: 5), () {
        return 'Data Received';
      });


  int setcolumnIndexnum(int pcolumnIndexnum){
    columnIndexnum = pcolumnIndexnum;
    return columnIndexnum;
  }

  void rowDataColumns (List json,List<dynamic> jsonHeaders){
    List<DataRow> rowsReturn = <DataRow> [];
    for (Map i in json){
    
      // DataClass a = new DataClass ( i[jsonHeaders[0]].toString(),
      //                               i[jsonHeaders[1]].toString(),
      //                               i[jsonHeaders[2]].toString(),
      //                               i[jsonHeaders[3]].toString());
      // print(a.toString());
      // print('inside');
      // print (i);
      rowsReturn.add(
        DataRow(
          cells: rowDataCells(i,jsonHeaders),
        )
      );
      
    }
    this.rowDataColumnsFields = rowsReturn;
    if(sort == true)  
      this.rowDataColumnsFields.sort((a,b){
          Text cmp1 = a.cells[columnIndexnum].child;
          Text cmp2 = b.cells[columnIndexnum].child;
          return cmp1.data.compareTo(cmp2.data);
        });
    else
      this.rowDataColumnsFields.sort((a,b){
          Text cmp1 = a.cells[columnIndexnum].child;
          Text cmp2 = b.cells[columnIndexnum].child;
          return cmp2.data.compareTo(cmp1.data);
        });
  }


   

  List<DataCell> rowDataCells (Map<String,dynamic> json,List<dynamic> jsonHeaders){
    List<DataCell> cells = <DataCell> [];
    // implement for loop to increase cells.
    for (var i in jsonHeaders){
      cells.add(DataCell(Text(json[i].toString())));
    }
    

    return cells;
  }

}
