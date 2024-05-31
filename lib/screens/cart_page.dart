import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surgakicare/tools/currecy_formatter.dart';

class CartPage extends StatelessWidget {
  CartPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    'Keranjang Anda',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            CartItem(
              imageUrl:
                  'https://images.tokopedia.net/img/cache/900/VqbcmM/2024/3/8/78295558-2cf5-4a6f-b36f-5c25dbdbd502.jpg',
              title: 'Jaco Koziii Sandal Kesehatan & Refleksi',
              harga: 1298000,
              quantity: 10,
            ),
            SizedBox(height: 20),
            Text(
              'Total Belanjaan Anda :',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Rp 10.298.000',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: Text('PROSES'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CartItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final int harga;
  final int quantity;

  CartItem({
    required this.imageUrl,
    required this.title,
    required this.harga,
    this.quantity = 1,
  }) {}

  @override
  Widget build(BuildContext context) {
    final totalharga = 0;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 56, 83, 183),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Image.network(
            imageUrl,
            width: 100,
            height: 100,
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Text(
                  formatCurrency.format(harga),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'X $quantity',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
