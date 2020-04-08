    //IMPLEMENTATION
    // import dataTable into project as seen below.
    
    //import 'dartTable.dart' as table; 
    //Implementation of rest table Call instance of class in Stateful page.

    // table.DataTableClass test = new table.DataTableClass((){
    //   setState((){
    //     sort = !sort;
    //     print('this is inside class of the function of the main page');
    //   });
    //   }, json, context,sort);


    //Below is how you call the restTable()
    // Container(
    //   child: test.restTable(),
    //   padding: EdgeInsets.only(top:10,bottom:10),
    // ),


import 'package:flutter/material.dart';
import 'dart:async';

import 'dart:convert';
import 'package:http/http.dart' as http;



class DataTableClass{
  Function stateSetter;
  dynamic test;
  BuildContext context;
  bool sort = true;
  List<DataRow> rowDataColumnsFields;
  DataTableClass(this.stateSetter,this.test,this.context,this.sort);
  int columnIndexnum = 0;


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
                  "Balance": 2,
                  "Pending": 4,
                  "Entitlement": 8
                },
                {
                  "Leave Type": "Vacation",
                  "Balance": 2,
                  "Pending": 4,
                  "Entitlement": 8
                },
                {
                  "Leave Type": "Sick Leave",
                  "Balance": 4,
                  "Pending": 0,
                  "Entitlement": 5
                }
              ]
                
              });
            
            print ('below is the jsonbody');
            print (jsonDecode(jsonBody)['columns'][0]);
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
           
           
          stateSetter();
          rowDataColumns(json,jsonHeaders);
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
          Text cmp1 = a.cells[0].child;
          Text cmp2 = b.cells[0].child;
          return cmp1.data.compareTo(cmp2.data);
        });
    else
      this.rowDataColumnsFields.sort((a,b){
          Text cmp1 = a.cells[0].child;
          Text cmp2 = b.cells[0].child;
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
