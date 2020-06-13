import 'package:flutter_test/flutter_test.dart';
import 'package:tech_task/api/futureApi.dart';

void main(){
  group("API test", () {
    test('Ingredients', () async {
      var result = await getIngredients();
      print('TEST RESULT 01 - ${result.map((ingredients) => ingredients.title)}');
      expect(result != null, true);
    });

    test('Recipes', () async {
      var result = await getRecipes("Eggs");
      print('TEST RESULT 02 - ${result.map((recipes) => recipes.title)}');
      expect(result != null, true);
    });
  });
}