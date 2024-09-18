import 'package:aaelectroz_fe/models/product_model.dart';

class CartModel {
  int? id;
  ProductModel? product;
  int quantity = 0;

  CartModel({
    this.id,
    this.product,
    this.quantity = 0,
  });

 CartModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product = json['product'] != null ? ProductModel.fromJson(json['product']) : null;
    quantity = json['quantity'] ?? 0; // Default value jika tidak ada quantity
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product != null ? product!.toJson() : null,
      'quantity': quantity,
    };
  }

  double getTotalPrice() {
    if (product != null && product!.price != null) {
      return product!.price! * quantity;
    } else {
      return 0.0; // Mengembalikan 0 jika product atau price null
    }
  }
}
