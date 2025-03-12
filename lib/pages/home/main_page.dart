import 'package:aaelectroz_fe/pages/home/chat_page.dart';
import 'package:aaelectroz_fe/pages/home/home_page.dart';
import 'package:aaelectroz_fe/pages/home/profile_page.dart';
import 'package:aaelectroz_fe/pages/home/wishlist_page.dart';
import 'package:aaelectroz_fe/providers/page_provider.dart';
import 'package:aaelectroz_fe/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    PageProvider pageProvider = Provider.of<PageProvider>(context);

    // 🔹 Floating Button untuk Cart
    Widget cartButton() {
      return FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/cart');
        },
        backgroundColor: secondaryColor,
        child: Image.asset(
          'assets/icons/icon_cart.png',
          height: 22,
          width: 20,
        ),
      );
    }

    // 🔹 Bottom Navigation Bar
    Widget customBottomNav() {
      return ClipRRect(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
        child: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 12,
          color: backgroundColor4,
          clipBehavior: Clip.antiAlias,
          child: BottomNavigationBar(
            backgroundColor: backgroundColor4,
            currentIndex: pageProvider.currentIndex,
            onTap: (value) {
              pageProvider.currentIndex = value;
            },
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: Container(
                  margin: EdgeInsets.only(top: 15, bottom: 10),
                  child: Image.asset(
                    'assets/icons/icon_home.png',
                    width: 21,
                    color: pageProvider.currentIndex == 0
                        ? primaryColor
                        : Color(0xff808191),
                  ),
                ),
                label: '',
                tooltip: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  margin: EdgeInsets.only(top: 15, bottom: 10),
                  child: Image.asset(
                    'assets/icons/icon_chat.png',
                    width: 20,
                    color: pageProvider.currentIndex == 1
                        ? primaryColor
                        : Color(0xff808191),
                  ),
                ),
                label: '',
                tooltip: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  margin: EdgeInsets.only(top: 15, bottom: 10),
                  child: Image.asset(
                    'assets/icons/icon_wishlist.png',
                    width: 20,
                    color: pageProvider.currentIndex == 2
                        ? primaryColor
                        : Color.fromARGB(255, 173, 173, 187),
                  ),
                ),
                label: '',
                tooltip: 'Wishlist',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  margin: EdgeInsets.only(top: 15, bottom: 10),
                  child: Image.asset(
                    'assets/icons/icon_profile.png',
                    width: 20,
                    color: pageProvider.currentIndex == 3
                        ? primaryColor
                        : Color(0xff808191),
                  ),
                ),
                label: '',
                tooltip: 'Profile',
              ),
            ],
          ),
        ),
      );
    }

    // 🔹 Menentukan Halaman yang Akan Ditampilkan
    Widget body() {
      switch (pageProvider.currentIndex) {
        case 0:
          return HomePage(
            onCategorySelected: (String category) {
              setState(() {
                pageProvider.currentIndex = 0; // Pastikan tetap di home
              });
            },
          );
        case 1:
          return ChatPage();
        case 2:
          return WishlistPage();
        case 3:
          return ProfilePage();
        default:
          return HomePage(
            onCategorySelected: (String category) {
              setState(() {
                pageProvider.currentIndex = 0;
              });
            },
          );
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor:
          pageProvider.currentIndex == 0 ? backgroundColor1 : backgroundColor3,
      floatingActionButton: cartButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: customBottomNav(),
      body: body(),
    );
  }
}
