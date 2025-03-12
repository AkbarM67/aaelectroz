import 'package:aaelectroz_fe/models/message_model.dart';
import 'package:aaelectroz_fe/models/product_model.dart';
import 'package:aaelectroz_fe/providers/auth_provider.dart';
import 'package:aaelectroz_fe/services/message_service.dart';
import 'package:aaelectroz_fe/theme.dart';
import 'package:aaelectroz_fe/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailChatPage extends StatefulWidget {
  ProductModel product;
  DetailChatPage(this.product);

  @override
  _DetailChatPageState createState() => _DetailChatPageState();
}

class _DetailChatPageState extends State<DetailChatPage> {
  TextEditingController messageController = TextEditingController(text: '');
  Stream<List<MessageModel>>? messagesStream;  // Stream untuk pesan

  @override
  void initState() {
    super.initState();
    checkRoleAndLoadMessages();  // Panggil fungsi untuk memeriksa role dan memuat pesan
  }

  // Fungsi untuk mengambil role dari SharedPreferences dan menentukan stream pesan
  Future<void> checkRoleAndLoadMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? role = prefs.getString('role');  // Ambil role dari SharedPreferences

    // Ambil instance AuthProvider
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (role == 'admin') {
      // Jika user adalah admin, ambil semua pesan
      messagesStream = MessageService().getAllMessages();
    } else {
      // Jika user adalah user biasa, ambil pesan mereka sendiri
      messagesStream = MessageService().getMessagesByUserId(userId: authProvider.user.id);
    }

    setState(() {});  // Refresh UI setelah stream pesan ditentukan
  }

  // Fungsi untuk menambahkan pesan
  handleAddMessage() async {
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    await MessageService().addMessage(
      user: authProvider.user,
      isFromUser: true,
      product: widget.product,
      message: messageController.text,
    );

    setState(() {
      widget.product = UninitializedProductModel();
      messageController.text = '';
    });
  }

  // Header halaman
  PreferredSizeWidget header() {
    return PreferredSize(
      preferredSize: Size.fromHeight(70),
      child: AppBar(
        backgroundColor: backgroundColor1,
        centerTitle: false,
        title: Row(
          children: [
            Image.asset(
              'assets/image_shop_logo_online.png',
              width: 50,
            ),
            SizedBox(
              width: 12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'aaelectroz',
                  style: primaryTextStyle.copyWith(
                    fontWeight: medium,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Online',
                  style: secondaryTextStyle.copyWith(
                    fontWeight: light,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Input chat untuk mengirim pesan
  Widget chatInput() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.product is UninitializedProductModel
              ? SizedBox()
              : productPreview(),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 45,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: backgroundColor4,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: TextFormField(
                      controller: messageController,
                      style: primaryTextStyle,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Type Message...',
                        hintStyle: subtitleTextStyle,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              GestureDetector(
                onTap: handleAddMessage,
                child: Image.asset(
                  'assets/icons/Send_Button.png',
                  width: 45,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan preview produk
  Widget productPreview() {
    return Container(
      width: 225,
      height: 74,
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor5,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: primaryColor,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              widget.product.galleries![0].url!,
              width: 54,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.product.name!,
                  style: primaryTextStyle,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  '\$${widget.product.price}',
                  style: priceTextStyle.copyWith(
                    fontWeight: medium,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                widget.product = UninitializedProductModel();
              });
            },
            child: Image.asset(
              'assets/icons/button_close.png',
              width: 22,
            ),
          ),
        ],
      ),
    );
  }

  // Menampilkan isi chat berdasarkan stream
  Widget content() {
    return StreamBuilder<List<MessageModel>>(
      stream: messagesStream,  // Stream yang ditentukan oleh role
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isEmpty) {
            return Center(child: Text('No messages yet.'));
          }

          return ListView(
            padding: EdgeInsets.symmetric(
              horizontal: defaultMargin,
            ),
            children: snapshot.data!
                .map((MessageModel message) => ChatBubble(
                      isSender: message.isFromUser!,
                      text: message.message!,
                      product: message.product,
                    ))
                .toList(),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor3,
      appBar: header(),
      bottomNavigationBar: chatInput(),
      body: content(),
    );
  }
}
