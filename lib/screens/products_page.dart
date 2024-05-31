import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surgakicare/components/card.dart';
import 'package:surgakicare/dummydata.dart';

class ProductPage extends StatelessWidget {
  ProductPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    'Daftar Produk',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Cari Produk',
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  itemCount: productList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    mainAxisExtent: 250,
                  ),
                  itemBuilder: (context, index) {
                    var e = productList[index];
                    return ProductCard(
                      imageUrl: e['imageUrl'].toString(),
                      title: e['title'].toString(),
                      originalPrice: e['originalPrice'].toString(),
                      discountPrice: e['discountPrice'].toString(),
                      rating: double.parse(e['rating'].toString()),
                      ratingCount: int.parse(
                        e['ratingCount'].toString(),
                      ),
                      isPromo: e['isPromo'].toString() == "true" ? true : false,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
