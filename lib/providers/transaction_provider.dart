import 'package:aaelectroz_fe/models/cart_model.dart';
import 'package:aaelectroz_fe/services/transaction_service.dart';
import 'package:flutter/material.dart';

class TransactionProvider with ChangeNotifier {
  Future<bool> checkout(
    String token,
    List<CartModel> carts,
    double totalPrice,
    String address, // Tambahkan parameter address di sini
    String phone,   // Tambahkan parameter phone di sini
  ) async {
    try {
      // Panggil checkout di TransactionService dan tambahkan parameter address dan phone
      bool success = await TransactionService().checkout(
        token,
        carts,
        totalPrice,
        address, // Kirimkan address ke TransactionService
        phone    // Kirimkan phone ke TransactionService
      );

      return success;
    } catch (e) {
      print("Error in checkout: $e");
      return false;
    }
  }
}
