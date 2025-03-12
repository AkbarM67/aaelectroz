import 'package:flutter/material.dart';
import 'package:aaelectroz_fe/models/category_model.dart';
import 'package:aaelectroz_fe/services/category_service.dart';
import 'package:provider/provider.dart';
import 'package:aaelectroz_fe/providers/product_provider.dart';

class CategoryProvider with ChangeNotifier {

  
  List<CategoryModel> _categories = [];
  int? _selectedCategoryId;
  bool _isLoading = false;

  List<CategoryModel> get categories => _categories;
  int? get selectedCategoryId => _selectedCategoryId;
  bool get isLoading => _isLoading;

  set selectedCategoryId(int? id) {
    _selectedCategoryId = id;
    notifyListeners(); // 🔹 UI akan diperbarui
  }

  Future<void> getCategories(BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();

      List<CategoryModel> categories = await CategoryService().getCategories();
      _categories = categories;

      if (categories.isNotEmpty) {
        _selectedCategoryId = categories.first.id;
        // 🔹 Langsung ambil produk berdasarkan kategori pertama
        Provider.of<ProductProvider>(context, listen: false).getProductsByCategory(_selectedCategoryId as String);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectCategory(int categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
  }
}
