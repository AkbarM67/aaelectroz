import 'dart:convert';
import 'package:aaelectroz_fe/models/product_model.dart';
import 'package:http/http.dart' as http;

class ProductService {
  final String baseUrl = 'http://127.0.0.1:8000/api';

  Future<List<ProductModel>> getProducts() async {
    var url = '$baseUrl/products';
    var headers = {'Content-Type': 'application/json'};

    var response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body)['data']['data'];
      return data.map((item) => ProductModel.fromJson(item)).toList();
    } else {
      throw Exception('Gagal mengambil produk');
    }
  }

  Future<List<ProductModel>> getProductsByCategory(String categoryName) async {
  final url = '$baseUrl/products?category_name=$categoryName';

  try {
    final response = await http.get(Uri.parse(url), headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data']['data'] as List;
      return data.map((item) => ProductModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  } catch (e) {
    print("Error fetching products: $e");
    return [];
  }
}

  Future<List<ProductModel>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/products'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null && data['data']['data'] != null) {
          return (data['data']['data'] as List)
              .map((item) => ProductModel.fromJson(item))
              .toList();
        }
      }
      return []; // 🔹 Pastikan return list kosong jika tidak ada data
    } catch (e) {
      print("Error fetching products: $e");
      return []; // 🔹 Hindari return null, gunakan list kosong
    }
  }
}