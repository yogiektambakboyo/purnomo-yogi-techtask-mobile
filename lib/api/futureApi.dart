
import 'dart:convert';

import 'package:tech_task/config/configValue.dart';
import 'package:tech_task/models/modelIngredients.dart';
import 'package:tech_task/models/modelRecipes.dart';
import 'package:http/http.dart' as http;


Future<List<modelRecipes>> getRecipes(String Ingredients) async {
  try{
    var queryParameters = {
      'ingredients': Ingredients,
    };
    var url = Uri.https(base_url_pure,'/dev/recipes',queryParameters);
    var response = await http.get(url);
    if(response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      var rest = data as List;
      var result = rest.map<modelRecipes>((json) => modelRecipes.fromJson(json)).toList();
      return result;
    } else {
      throw Exception('Something error');
    }
  } catch(e) {
    throw Exception(e);
  }
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

