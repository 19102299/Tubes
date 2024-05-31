import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surgakicare/screens/account_page.dart';
import 'package:surgakicare/screens/cart_page.dart';
import 'package:surgakicare/screens/home_page.dart';
import 'package:surgakicare/screens/products_page.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final screens = [
    HomePage(),
    ProductPage(),
    CartPage(),
    AccountPage(),
  ];

  int pageidx = 0;

  void setPage(int page) {
    setState(() {
      pageidx = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Surgaki Care',
          style: GoogleFonts.alegreyaSansSc(
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 40,
            ),
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Color.fromARGB(255, 35, 46, 142),
      ),
      backgroundColor: Colors.white,
      body: screens[pageidx],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageidx,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Produk"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
        ],
        onTap: (value) {
          setPage(value);
        },
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
