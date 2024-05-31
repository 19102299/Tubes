import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surgakicare/components/card.dart';
import 'package:surgakicare/dummydata.dart';

class HomePage extends StatelessWidget {
  HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 24,
              ),
              Text(
                'Yang Lagi Diskon Nih...',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 10),
              CarouselSlider(
                options: CarouselOptions(
                  height: 300,
                  enableInfiniteScroll: true,
                  viewportFraction: 0.4,
                  enlargeCenterPage: false,
                  autoPlay: true,
                ),
                items: productList.where((e) => e['isPromo'] == true).map((e) {
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
                }).toList(),
              ),
              SizedBox(
                height: 24,
              ),
              Text(
                'Rating Tertinggi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 10),
              CarouselSlider(
                options: CarouselOptions(
                  height: 300,
                  enableInfiniteScroll: true,
                  viewportFraction: 0.4,
                  enlargeCenterPage: false,
                  autoPlay: true,
                ),
                items: productList.toList().map((e) {
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
                }).toList(),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
