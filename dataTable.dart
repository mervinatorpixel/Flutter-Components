import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:apptrin_hr/UI/shared/DataTable/dartTableDetail.dart';


class DataTableClass {
  Function stateSetter;
  BuildContext context;
  static bool sort = true;
  List<DataRow> rowDataColumnsFields;
  double colSize;
  static int columnIndexnum = 0;
  Future<http.Response> postRequest;
  
  DataTableClass(this.stateSetter,this.postRequest,this.context,{this.colSize = 80.0});  
  
  //DataTableClass(this.stateSetter,this.link,this.context, {this.colSize = 80.0}); 


  
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
        //future: getFutureData(),
        // future: http.post(
        //         link,
        //         headers: <String, String>{
        //           'Content-Type': 'application/json; charset=UTF-8',
        //         },
        //         body: json.encode({
        //                 "procedure": {
        //                   "PROCEDURE_NAME": "REST\$MERVIN_TEST_DATATABLE_DART",
        //                   "PROCEDURE_DATA": "{ \"P_LEAVE_TYPES_ID\": \"1\", \"P_SHIFTS_ID\": \"null\" }"
        //                 }
        //               }),
        //           ),
        future: postRequest,
        builder: (context,snapshot){
          if (snapshot.hasData && snapshot.data.statusCode == 200){
             
            dynamic jsonBody = json.decode(snapshot.data.body);
            jsonBody = json.encode(jsonBody);
            jsonBody = jsonDecode(jsonBody)['value'];
            jsonBody = json.encode(jsonBody);
            //print(jsonBody);
            //print(snapshot.data.body);
            //final jsonBody = json.decode(snapshot.data.body); 
            // final jsonBody = json.encode({
            //   "columns" : [
            //     "Leave Type",
            //       "Balance",
            //       "Pending",
            //       "Entitlement"
            //   ],

            //   "data": [
            //     {
            //       "Leave Type": "Xacation",
            //       "Balance": 1.21,
            //       "Pending": 22,
            //       "Entitlement": 33
            //     },
            //     {
            //       "Leave Type": "Vacation",
            //       "Balance": 1.99,
            //       "Pending": 23,
            //       "Entitlement": 34
            //     },
            //     {
            //       "Leave Type": "Sick Leave",
            //       "Balance": 1.9123,
            //       "Pending": 24,
            //       "Entitlement": 35
            //     }
            //   ]
                
            //   });
            
            print ('below is the jsonbody');
            print (jsonDecode(jsonBody)['columns'][0]);
            rowDataColumns(jsonDecode(jsonBody)['data'],jsonDecode(jsonBody)['columns']);
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                sortColumnIndex: columnIndexnum,
                sortAscending: sort,
                columns: headDataColumns(jsonDecode(jsonBody)['columns'],jsonDecode(jsonBody)['data'],jsonDecode(jsonBody)['columns']),
                rows: rowDataColumnsFields,
               ),
            );
            
            //return Text(snapshot.data.body);
          }
          else if(snapshot.hasData && snapshot.data.statusCode != 200){
            return Text('Error Response from Server : ' + snapshot.data.statusCode.toString());
          }
          else{
            //print(snapshot.data);
            return Container(
              width: 40,
              child: CircularProgressIndicator(),
            );
          }


          }
        );
        
  
  }





  List<DataColumn> headDataColumns(List<dynamic> json, List json2,List<dynamic> jsonHeaders){
    List<DataColumn> listReturn = <DataColumn> [];
    
    //print ((json.elementAt(0)).runtimeType);
    for (var i in json){
      listReturn.add(setDataColumn(context,this.colSize,i,json2,jsonHeaders));
    }
    print('worked');
    return listReturn;
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
          child: Text(ctext,style: TextStyle(
              color: Colors.green,
              decoration: TextDecoration.underline,
            ),
          )
        ),
    );
  }




 


  int setcolumnIndexnum(int pcolumnIndexnum){
    columnIndexnum = pcolumnIndexnum;
    return columnIndexnum;
  }

  void rowDataColumns (List json,List<dynamic> jsonHeaders){
    List<DataRow> rowsReturn = <DataRow> [];
    for (Map i in json){
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
      cells.add(DataCell(
                  Text(json[i].toString()),
                onTap: (){
                  print(i);
                  print(json);
                  print(json.length);
                  print(json.keys.elementAt(0));
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsClass(data: json),
                    ),
                  );
                  
                  
                }  
                )
              );
    }
    return cells;
  }

}
