class CategoryModel {
  int? id;
  String? name;

  CategoryModel({
    required this.id,
    required this.name,
  });

CategoryModel.fromJson(Map<String, dynamic> json) {
  this.id = json['id'];
  this.name = json['name'];
}

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
