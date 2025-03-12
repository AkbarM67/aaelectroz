import 'package:aaelectroz_fe/models/cart_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TransactionService {
  final String _baseUrl = 'http://127.0.0.1:8000/api';

  Future<bool> checkout(
    String token,
    List<CartModel> carts,
    double totalPrice,
    String address,
    String phone, // Tambahkan parameter phone
  ) async {
    var url = '$_baseUrl/checkout';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var body = jsonEncode(
      {
        'address': address,
        'phone': phone, // Tambahkan phone di dalam body request
        'items': carts
            .map(
              (cart) => {
                'id': cart.product!.id,
                'quantity': cart.quantity,
              },
            )
            .toList(),
        'status': "PENDING",
        'total_price': totalPrice,
        'shipping_price': 0,
      },
    );

    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    print(response.body);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to process checkout!');
    }
  }
}
