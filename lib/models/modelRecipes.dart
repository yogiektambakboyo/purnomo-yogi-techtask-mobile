import 'dart:convert';

//List<modelRecipes> recipeModelFromJson(String str) => List<modelRecipes>.from(json.decode(str).map((x) => modelRecipes.fromJson(x)));
//String recipeModelToJson(List<modelRecipes> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class modelRecipes {
  String title;
  List<String> ingredients;

  modelRecipes({
    this.title,
    this.ingredients,
  });

  String get stringredients{
    return "Ingredients : "+this.ingredients.join(", ");
  }

  factory modelRecipes.fromJson(Map<String, dynamic> json) {
    return
      modelRecipes(
        title: json["title"],
        ingredients: List<String>.from(json["ingredients"]),
      );
    /*Map<String, dynamic> toJson()=> {
    "title": title,
    "ingredients": List<dynamic>.from(ingredients.map((x) => x)),
  };*/
  }
}