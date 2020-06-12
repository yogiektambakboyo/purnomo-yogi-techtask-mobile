class modelIngredients {
  String title,use_by;

  modelIngredients({this.title, this.use_by});

  factory modelIngredients.fromJson(Map<String, dynamic> json) {
    return modelIngredients(
      title : json['title'],
      use_by : json['use-by'],
    );
  }
}