// import 'package:aaelectroz_fe/providers/auth_provider.dart';
// import 'package:aaelectroz_fe/providers/cart_provider.dart';
// import 'package:aaelectroz_fe/providers/transaction_provider.dart';
// import 'package:aaelectroz_fe/theme.dart';
// import 'package:aaelectroz_fe/widgets/loading_button.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class PaymentPage extends StatefulWidget {
//   const PaymentPage({super.key});

//   @override
//   State<PaymentPage> createState() => _PaymentPageState();
// }

// class _PaymentPageState extends State<PaymentPage> {
//   String? va;
//   bool isLoading = false;

//   @override
//   Widget build(BuildContext context) {
//     CartProvider cartProvider = Provider.of<CartProvider>(context);
//     TransactionProvider transactionProvider =
//         Provider.of<TransactionProvider>(context);
//     AuthProvider authProvider = Provider.of<AuthProvider>(context);

//     // Fungsi checkout tanpa Midtrans, langsung menyimpan data ke database
//     handleCheckout() async {
//       if (va == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Pilih metode pembayaran")),
//         );
//         return;
//       }

//       setState(() {
//         isLoading = true;
//       });

//       // Kirim data ke database menggunakan transactionProvider
//       bool success = await transactionProvider.saveTransaction(
//         token: authProvider.user.token!,
//         carts: cartProvider.carts,
//         totalAmount: cartProvider.totalPrice(),
//         paymentMethod: va!,  // Metode pembayaran
//       );

//       if (success) {
//         cartProvider.carts = [];
//         Navigator.pushNamedAndRemoveUntil(
//             context, '/checkout-success', (route) => false);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Pembayaran gagal, coba lagi")),
//         );
//       }

//       setState(() {
//         isLoading = false;
//       });
//     }

//     AppBar header() {
//       return AppBar(
//         backgroundColor: backgroundColor1,
//         elevation: 0,
//         centerTitle: true,
//         title: Text('Payment Details'),
//       );
//     }

//     Widget card() {
//       return Container(
//         width: double.infinity,
//         height: 150,
//         margin: EdgeInsets.all(defaultMargin),
//         padding: EdgeInsets.all(defaultMargin),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           color: backgroundColor4,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               authProvider.user.name!,
//               style: primaryTextStyle.copyWith(
//                 fontSize: 16,
//                 fontWeight: bold,
//               ),
//             ),
//             SizedBox(height: 15),
//             Text('Total Price', style: primaryTextStyle),
//             Text('\$${cartProvider.totalPrice()}', style: priceTextStyle),
//           ],
//         ),
//       );
//     }

//     Widget content() {
//       return Container(
//         margin: EdgeInsets.all(defaultMargin),
//         child: Column(
//           children: [
//             RadioListTile(
//               tileColor: backgroundColor4,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               value: "bni",
//               groupValue: va,
//               onChanged: (value) {
//                 setState(() {
//                   va = value.toString();
//                 });
//               },
//               title: Row(
//                 children: [
//                   Image.network(
//                     'https://seeklogo.com/images/B/bank-bni-logo-737EE0F32C-seeklogo.com.png',
//                     width: 50,
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 10),
//             RadioListTile(
//               tileColor: backgroundColor4,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               value: "bca",
//               groupValue: va,
//               onChanged: (value) {
//                 setState(() {
//                   va = value.toString();
//                 });
//               },
//               title: Row(
//                 children: [
//                   Image.network(
//                     'https://seeklogo.com/images/B/bca-bank-logo-1E89320DC2-seeklogo.com.png',
//                     width: 60,
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 10),
//             RadioListTile(
//               tileColor: backgroundColor4,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               value: "mandiri",
//               groupValue: va,
//               onChanged: (value) {
//                 setState(() {
//                   va = value.toString();
//                 });
//               },
//               title: Row(
//                 children: [
//                   Image.network(
//                     'https://seeklogo.com/images/B/bank_mandiri-logo-4F6233ABCC-seeklogo.com.png',
//                     width: 60,
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 10),
//             RadioListTile(
//               tileColor: backgroundColor4,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               value: "gopay",
//               groupValue: va,
//               onChanged: (value) {
//                 setState(() {
//                   va = value.toString();
//                 });
//               },
//               title: Row(
//                 children: [
//                   Image.network(
//                     'https://seeklogo.com/images/G/gopay-logo-D27C1EBD0D-seeklogo.com.png',
//                     width: 60,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     Widget paymentButton() {
//       return isLoading
//           ? Container(
//               width: double.infinity,
//               margin: EdgeInsets.all(defaultMargin),
//               child: LoadingButton(),
//             )
//           : Container(
//               height: 50,
//               width: double.infinity,
//               margin: EdgeInsets.all(defaultMargin),
//               child: TextButton(
//                 onPressed: handleCheckout,
//                 style: TextButton.styleFrom(
//                   backgroundColor: primaryColor,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: Text(
//                   'Pay Now',
//                   style: primaryTextStyle.copyWith(
//                     fontSize: 16,
//                     fontWeight: medium,
//                   ),
//                 ),
//               ),
//             );
//     }

//     return Scaffold(
//       backgroundColor: backgroundColor3,
//       appBar: header(),
//       body: Column(
//         children: [
//           card(),
//           content(),
//           Spacer(),
//           paymentButton(),
//         ],
//       ),
//     );
//   }
// }
