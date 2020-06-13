import 'package:flutter/material.dart';
import 'package:tech_task/config/config_value.dart';
import 'package:tech_task/screens/screenIngredients.dart';
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

