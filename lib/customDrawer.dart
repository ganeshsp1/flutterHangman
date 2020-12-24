import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget{
  final String _currentWord;
  CustomDrawer(this._currentWord);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            padding: EdgeInsets.all(0),
            margin: EdgeInsets.all(0),
            child: Container(child: Text('DEBUG',style: TextStyle(fontSize: 40),textAlign: TextAlign.center,),padding: EdgeInsets.all(50),),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
             ListTile(
                    title: Text(_currentWord,style: TextStyle(fontSize: 20)),
                    onTap: (){},
                    ),
            ],
            ),
          ),
        ],
      ),
   );
  }

}