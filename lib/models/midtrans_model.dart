import 'package:aaelectroz_fe/models/bank_model.dart';

class MidtransModel {
  late String transactionId;
  late String orderId;
  late String merchantId;
  late String statusCode;
  late String statusMessage;
  late String grossAmount;
  late String currency;
  late String paymentType;
  late DateTime transactionTime;
  late String transactionStatus;
  late String fraudStatus;
  late String? billKey;
  late String? billerCode;
  late BankModel? vaNumbers;

  MidtransModel({
    required this.transactionId,
    required this.orderId,
    required this.merchantId,
    required this.statusCode,
    required this.statusMessage,
    required this.grossAmount,
    required this.currency,
    required this.paymentType,
    required this.transactionTime,
    required this.transactionStatus,
    required this.fraudStatus,
    this.billKey,
    this.billerCode,
    this.vaNumbers,
  });

  MidtransModel.fromJson(Map<String, dynamic> json) {
    transactionId = json['transaction_id'];
    orderId = json['order_id'];
    merchantId = json['merchant_id'];
    statusCode = json['status_code'];
    statusMessage = json['status_message'];
    grossAmount = json['gross_amount'];
    currency = json['currency'];
    paymentType = json['payment_type'];
    transactionTime = DateTime.parse(json['transaction_time']);
    transactionStatus = json['transaction_status'];
    fraudStatus = json['fraud_status'];
    billKey = json['bill_key'];
    billerCode = json['biller_code'];
    // vaNumbers = json['va_numbers'] == null
    //     ? UninitializedBankModel()
    //     : json['va_numbers']
    //         .map<BankModel>((bank) => BankModel.fromJson(bank))
    //         .toList();
    vaNumbers = json['va_numbers'] == null
        ? UninitializedBankModel()
        : BankModel.fromJson(json['va_numbers'][0]);
  }

  Map<String, dynamic> toJson() {
    return {
      'transaction_id': transactionId,
      'order_id': orderId,
      'merchant_id': merchantId,
      'status_code': statusCode,
      'status_message': statusMessage,
      'gross_amount': grossAmount,
      'currency': currency,
      'payment_type': paymentType,
      'transaction_time': transactionTime,
      'transaction_status': transactionStatus,
      'fraud_status': fraudStatus,
      'bill_key': billKey!,
      'biller_code': billerCode!,
      // 'va_numbers': vaNumbers is UninitializedBankModel
      //     ? {}
      //     : vaNumbers!.map((bank) => bank.toJson()).toList(),
      'va_numbers':
          vaNumbers is UninitializedBankModel ? {} : vaNumbers!.toJson(),
    };
  }
}
