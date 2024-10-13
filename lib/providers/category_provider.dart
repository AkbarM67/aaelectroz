import 'package:aaelectroz_fe/services/category_service.dart';
import 'package:flutter/material.dart';
import 'package:aaelectroz_fe/models/category_model.dart'; // Pastikan ini mengarah ke model kategori kamu

class CategoryProvider with ChangeNotifier {
  List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => _categories;
  set categories(List<CategoryModel> categories) {
    _categories = categories;
    notifyListeners();
  }

  Future<void> getCategories() async {
    try {
      List<CategoryModel> categories = await CategoryService().getCategories();
      _categories = categories;
    } catch (e) {
      print(e);
    }
  }
}
