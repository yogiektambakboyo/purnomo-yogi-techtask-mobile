import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:tech_task/api/futureApi.dart';
import 'package:tech_task/config/config_value.dart';
import 'package:tech_task/models/modelIngredients.dart';
import 'package:tech_task/models/modelRecipes.dart';
import 'package:tech_task/screens/screenRecipes.dart';


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

class screenIngredients extends StatefulWidget{
  screenIngredients({Key key}) : super(key:key);

  @override

  _screenIngredientsState createState(){
    return _screenIngredientsState();
  }
}

class _screenIngredientsState extends State<screenIngredients> {
  Future<List<modelIngredients>> futureIngredients;
  DateTime dateSelected = DateTime.now();
  final dateFormat = new DateFormat('yyyy-MM-dd');
  List<modelIngredients> listAll = [];
  List<modelIngredients> listFiltered = [];
  int ingredientCounter = 0;

  @override
  void initState() {
    super.initState();
    futureIngredients = getIngredients();
  }

  void setDate(DateTime date){
    setState(() {
      dateSelected = date;
    });
  }

  void countIngredients(){
    setState(() {
      ingredientCounter=0;
      for(int i=0;i<listFiltered.length;i++){
        if(listFiltered[i].ischoice){
          ingredientCounter++;
        }
      }
    });
  }

  void resetIngredientsList(){
    setState(() {
      for(int i=0;i<listFiltered.length;i++){
        listFiltered[i].ischoice = false;
      }
    });
    countIngredients();
  }

  String resultIngredients(){
    List<String> arrResult = [];
    for(int i=0;i<listFiltered.length;i++){
      if(listFiltered[i].ischoice){
        arrResult.add(listFiltered[i].title);
      }
    }
    return arrResult.join(",");
  }

  ListTile _tile(String title, String subtitle, bool ischeck,int idx) => ListTile(
    title: Text(title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
        )),
    subtitle: Text(subtitle),
    leading: InkWell(
      child: (ischeck)
          ? Icon(
        Icons.check,
      )
          : Icon(Icons.cake),
    ),
    onTap: (){
      if(ischeck){
        listFiltered[idx].ischoice = false;
      }else{
        listFiltered[idx].ischoice = true;
      }
      countIngredients();
      setState(() {

      });
    },
  );


  ListView _IngredientsListView(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _tile(data[index].title, data[index].date, data[index].ischoice, index);
        });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(app_name),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: new Text(
                dateFormat.format(dateSelected),
                style: new TextStyle(
                  fontSize: 25.0,
                  color: new Color(0xFF8B1122),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            FlatButton(
                onPressed: () {
                  DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      minTime: DateTime(2017, 1, 1),
                      theme: DatePickerTheme(
                          headerColor: Colors.orange,
                          backgroundColor: Colors.blue,
                          itemStyle: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                          doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
                      onChanged: (date) {
                        print('change $date in time zone ' + date.timeZoneOffset.inHours.toString());
                      }, onConfirm: (date) {
                        print('confirm $date');
                        resetIngredientsList();
                        setDate(date);
                      }, currentTime: DateTime.now(), locale: LocaleType.en);
                },
                child: Text(
                  'Click here for change Date',
                  style: TextStyle(color: Colors.blue),
                )),
            RaisedButton(
              child: new Text("Get Recipes ( $ingredientCounter )"),
              onPressed: (){
                if(ingredientCounter>0){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => screenRecipes(stringredients : resultIngredients())));
                }else{
                  Fluttertoast.showToast(
                      msg: "Please pick at least 1 ingredient to get recipes",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                }
              },
            ),
            Expanded(child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<List<modelIngredients>>(
                  future: futureIngredients,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot == null) {
                        print("Empty");
                      }
                      listAll = [];
                      listFiltered = [];
                      listAll = snapshot.data;
                      for(int i=0;i<listAll.length;i++){
                        if(listAll[i].useby.isAfter(dateSelected)){
                          listFiltered.add(listAll[i]);
                        }
                      }
                      return _IngredientsListView(listFiltered);
                    } else if (snapshot.hasError) {
                      print("Error");
                      print(snapshot.error.toString());
                    }
                    return CircularProgressIndicator();
                  }),
            ))
          ],
        )
    );
  }
}
