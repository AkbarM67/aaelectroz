import 'package:aaelectroz_fe/models/product_model.dart';
import 'package:aaelectroz_fe/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aaelectroz_fe/models/message_model.dart';

class MessageService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Fungsi untuk mengambil semua pesan (digunakan oleh admin)
  Stream<List<MessageModel>> getAllMessages() {
    try {
      // Mengambil semua pesan dari Firestore, tanpa filter
      return firestore.collection('messages').snapshots().map((QuerySnapshot list) {
        var result = list.docs.map<MessageModel>((DocumentSnapshot message) {
          return MessageModel.fromJson(message.data() as Map<String, dynamic>);
        }).toList();

        // Urutkan pesan berdasarkan waktu pembuatan (createdAt)
        result.sort(
          (MessageModel a, MessageModel b) => a.createdAt!.compareTo(b.createdAt!),
        );

        return result;
      });
    } catch (e) {
      throw Exception('Gagal mengambil pesan: $e');
    }
  }

  // Fungsi untuk mengambil pesan berdasarkan userId
  Stream<List<MessageModel>> getMessagesByUserId({int? userId}) {
    try {
      return firestore
          .collection('messages')
          .where('userId', isEqualTo: userId)
          .snapshots()
          .map((QuerySnapshot list) {
        var result = list.docs.map<MessageModel>((DocumentSnapshot message) {
          return MessageModel.fromJson(message.data() as Map<String, dynamic>);
        }).toList();

        result.sort(
          (MessageModel a, MessageModel b) =>
              a.createdAt!.compareTo(b.createdAt!),
        );

        return result;
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  // Fungsi untuk menambahkan pesan ke Firestore
  Future<void> addMessage({
    required UserModel user,
    required bool isFromUser,
    required String message,
    ProductModel? product,
  }) async {
    try {
      firestore.collection('messages').add({
        'userId': user.id,
        'userName': user.name,
        'userImage': user.profilePhotoUrl,
        'isFromUser': isFromUser,
        'message': message,
        'product': product is UninitializedProductModel ? {} : product!.toJson(),
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      }).then((value) => print('Pesan Berhasil Dikirim!'));
    } catch (e) {
      throw Exception('Pesan Gagal Dikirim!');
    }
  }
}
