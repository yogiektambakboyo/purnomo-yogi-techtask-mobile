import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:tech_task/config/config_value.dart';
import 'package:tech_task/models/modelIngredients.dart';


void main() {
  runApp(MaterialApp(
    title: app_name,
    // Start the app with the "/" named route. In this case, the app starts
    // on the FirstScreen widget.
    initialRoute: '/',
    routes: {
      '/' : (context) => MainScreen(),
      // When navigating to the "/" route, build the FirstScreen widget.
      '/x': (context) => MainScreen(),
    },
  ));
}

Future<List<modelIngredients>> getIngredients() async {
  try{
    var url = base_url+'/ingredients';
    var response = await http.get(url);
    if(response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      var rest = data as List;
      var result = rest.map<modelIngredients>((json) => modelIngredients.fromJson(json)).toList();
      return result;
    } else {
      throw Exception('Something error');
    }
  } catch(e) {
    throw Exception(e);
  }
}


class MainScreen extends StatefulWidget{
  MainScreen({Key key}) : super(key:key);

  @override

  _MainScreenState createState(){
    return _MainScreenState();
  }
}

class _MainScreenState extends State<MainScreen> {
  Future<List<modelIngredients>> futureIngredients;
  DateTime dateSelected = DateTime.now();
  final f = new DateFormat('yyyy-MM-dd');
  List<modelIngredients> listAll = [];
  List<modelIngredients> listFiltered = [];


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
      print(title);
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
                f.format(dateSelected),
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
                        setDate(date);
                      }, currentTime: DateTime.now(), locale: LocaleType.en);
                },
                child: Text(
                  'Click here for change Date',
                  style: TextStyle(color: Colors.blue),
                )),
            Expanded(child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<List<modelIngredients>>(
                  future: futureIngredients,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot == null) {
                        print("Data Kosong");
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
