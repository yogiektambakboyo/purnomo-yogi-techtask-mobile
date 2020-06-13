import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:tech_task/api/futureApi.dart';
import 'package:tech_task/config/configValue.dart';
import 'package:tech_task/models/modelRecipes.dart';
import 'package:tech_task/screens/screenIngredients.dart';

import '../main.dart';


void main() {
  runApp(MaterialApp(
    title: app_name,
    // Start the app with the "/" named route. In this case, the app starts
    // on the FirstScreen widget.
    initialRoute: '/',
    routes: {
      '/' : (context) => screenIngredients(),
      // When navigating to the "/" route, build the FirstScreen widget.
      '/screenRecipes': (context) => screenRecipes(),
    },
  ));
}

class screenRecipes extends StatefulWidget{
  final String stringredients;
  screenRecipes({Key key,@required this.stringredients}) : super(key:key);

  @override
  _screenRecipesState createState(){
    return _screenRecipesState();
  }
}

class _screenRecipesState extends State<screenRecipes> {
  DateTime dateSelected = DateTime.now();
  final dateFormat = new DateFormat('yyyy-MM-dd');
  List<modelRecipes> listAll = [];
  Future<List<modelRecipes>> futureRecipes;

  @override
  void initState() {
    super.initState();
    futureRecipes = getRecipes(widget.stringredients);
  }

  ListTile _tile(String title,String strindg,int idx) => ListTile(
    title: Text(title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
        )),
    subtitle: Text(strindg),
    leading: InkWell(
      child: Icon(Icons.cake) ,
    ),
  );


  ListView _RecipesListView(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _tile(data[index].title, data[index].stringredients,index);
        });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(app_name),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<List<modelRecipes>>(
              future: futureRecipes,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot == null) {
                    print("Data Kosong");
                  }
                  listAll = [];
                  listAll = snapshot.data;
                  //print(listAll[0].title);
                  return _RecipesListView(listAll);
                } else if (snapshot.hasError) {
                  print("Error");
                  print(snapshot.error.toString());
                }
                return CircularProgressIndicator();
              }),
        ),
    );
  }
}
