import 'package:aaelectroz_fe/providers/transaction_provider.dart';
import 'package:aaelectroz_fe/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckoutSuccessPage extends StatelessWidget {
  const CheckoutSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    TransactionProvider transactionProvider =
        Provider.of<TransactionProvider>(context);

    String isPayType = transactionProvider.midtrans.paymentType;

    header() {
      return AppBar(
        backgroundColor: backgroundColor1,
        centerTitle: true,
        title: Text(
          'Checkout Success',
        ),
        elevation: 0,
      );
    }

    Widget vaList() {
      return Container(
        child: Column(
          children: [
            Text(
              'Bank : ${transactionProvider.midtrans.vaNumbers!.bank}',
              style: secondaryTextStyle,
              textAlign: TextAlign.center,
            ),
            Text(
              'Va Number : ${transactionProvider.midtrans.vaNumbers!.vaNumber}',
              style: secondaryTextStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    Widget vaList1() {
      return Container(
        child: Column(
          children: [
            Text(
              'Bank : ${transactionProvider.midtrans.paymentType}',
              style: secondaryTextStyle,
              textAlign: TextAlign.center,
            ),
            Text(
              'Bill Key : ${transactionProvider.midtrans.billKey}',
              style: secondaryTextStyle,
              textAlign: TextAlign.center,
            ),
            Text(
              'Biller Code : ${transactionProvider.midtrans.billerCode}',
              style: secondaryTextStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    Widget vaList2() {
      return Container(
        child: Column(
          children: [
            Text(
              'Bank : ${transactionProvider.midtrans.paymentType}',
              style: secondaryTextStyle,
              textAlign: TextAlign.center,
            ),
            Text(
              'Bill Key : ${transactionProvider.midtrans.billKey}',
              style: secondaryTextStyle,
              textAlign: TextAlign.center,
            ),
            Text(
              'Biller Code : ${transactionProvider.midtrans.billerCode}',
              style: secondaryTextStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    Widget content() {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icon_empty_cart.png',
              width: 80,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'You made a transaction',
              style: primaryTextStyle.copyWith(
                fontSize: 16,
                fontWeight: medium,
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              'Lakukan pembayaran untuk\nmenyelesaikan transaksi',
              style: secondaryTextStyle,
              textAlign: TextAlign.center,
            ),
            Text(
              'Total Harga : ${transactionProvider.midtrans.grossAmount}',
              style: primaryTextStyle.copyWith(fontWeight: bold),
              textAlign: TextAlign.center,
            ),
            isPayType == 'echannel' ? vaList1() : vaList(),
            Container(
              width: 196,
              height: 44,
              margin: EdgeInsets.only(top: defaultMargin),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Order Other Shoes',
                  style: primaryTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: medium,
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/home', (route) => false);
                },
              ),
            ),
            Container(
              width: 196,
              height: 44,
              margin: EdgeInsets.only(top: 12),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xff39374B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'View My Order',
                  style: primaryTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: medium,
                    color: Color(0xffB7B6BF),
                  ),
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor3,
      appBar: header(),
      body: content(),
    );
  }
}
