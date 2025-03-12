import 'package:flutter/material.dart';
import 'package:aaelectroz_fe/models/product_model.dart';
import 'package:aaelectroz_fe/services/product_service.dart';

class ProductProvider with ChangeNotifier {
  List<ProductModel> _products = [];
  bool _isLoading = false;

  List<ProductModel> get products => _products;
  bool get isLoading => _isLoading;

  Future<void> getProductsByCategory(String categoryName) async {
    try {
      _isLoading = true;
      _products.clear(); // 🔹 Pastikan produk lama dihapus sebelum fetch produk baru
      notifyListeners();
 
      _products = await ProductService().getProductsByCategory(categoryName);

      print("Products fetched: ${_products.length}");
      print(_products.map((p) => p.name).toList()); // 🔹 Cek isi produk yang diambil

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print("Error fetching products by category: $e");
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getProducts() async {
  try {
    _isLoading = true;
    notifyListeners(); // 🔹 Update state biar loading muncul

    List<ProductModel> products = await ProductService().fetchProducts();
    _products = products ?? [];

    _isLoading = false;
    notifyListeners(); // 🔹 Update state biar produk tampil
  } catch (e) {
    print("Error fetching products: $e");
    _isLoading = false;
    notifyListeners();
  }
}
}
