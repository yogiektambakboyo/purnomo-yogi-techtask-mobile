class modelIngredients {
  String title;
  DateTime useby;
  bool ischoice;

  String get date {
    return useby.toString().substring(0, 10);
  }

  modelIngredients({this.title, this.useby, this.ischoice: false});

  factory modelIngredients.fromJson(Map<String, dynamic> json) {
    return modelIngredients(
        title: json['title'],
        useby: DateTime.parse(json['use-by'] as String)
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['use-by'] = this.useby;
    return data;
  }
}