import 'dart:convert';
import 'package:aaelectroz_fe/models/category_model.dart';
import 'package:http/http.dart' as http;


class CategoryService {
  String baseUrl = 'http://127.0.0.1:8000/api';

  Future<List<CategoryModel>> getCategories() async {
    var url = '$baseUrl/categories';

    var headers = {'Content-Type': 'application/json'};
    var response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    print("Response Status Code: ${response.statusCode}");

    print("Response: ${response.body}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedData = jsonDecode(response.body);

      if (decodedData.containsKey('data') && decodedData['data'].containsKey('data')) {
        final List<dynamic> data = decodedData['data']['data'];

        return data.map((item) => CategoryModel.fromJson(item)).toList();
      } else {
        throw Exception("Invalid API Response Format");
      }
    } else {
      throw Exception('Gagal Get Categories: ${response.statusCode}');
    }
  }
}
