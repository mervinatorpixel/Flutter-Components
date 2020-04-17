import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
class DetailsClass extends StatefulWidget{
  final Map<String,dynamic> data;
  DetailsClass({Key key,@required this.data}) : super(key:key);
  _DetailsClassState createState() => _DetailsClassState();
}

class _DetailsClassState extends State<DetailsClass>{
  
   
  List<TableRow> returnRows(){
 
    List<TableRow> rows = [];
    List<Widget> list = [];
    // int nrows = widget.data.length % 3;
    // if (nrows != 0) nrows = nrows + 1;
    int last = 0;
    for (int i = 0; i< widget.data.length; i++){
      //print(i);
      list.add(
        Container(
          padding: EdgeInsets.only(bottom : 30,left: 60),
          child : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(widget.data.keys.elementAt(i) + ':',style: TextStyle(
                color: Colors.green,
                decoration: TextDecoration.underline,
              ),),
              Container(
                padding : EdgeInsets.only(left: 10),
                child : Text(widget.data[widget.data.keys.elementAt(i)])
              ),
            ],
          )
        ),
      );
       
      if(list.length % 2 == 0){
        //print('in the if sttment');
        TableRow addTo = new TableRow(children: list);
        rows.add(addTo);
        last = i;
        list = [];
      }

    }
    if(last % 2 == 0){
      list.add(
        Text('')
      );
      TableRow addTo = new TableRow(children: list);
      rows.add(addTo);
    }
    return rows;
  }

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title : Text(''),
        backgroundColor: Color(0xFF21BFBD)
      ),
      body:  
        SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top:100),
            child : Table(
              children: returnRows(),
            ),
          ),
        ),
       
    );
  }
}