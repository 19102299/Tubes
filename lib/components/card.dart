import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:surgakicare/screens/detail_product_page.dart';

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String originalPrice;
  final String discountPrice;
  final double rating;
  final int ratingCount;
  final bool isPromo;
  final bool isSaved;

  ProductCard({
    required this.imageUrl,
    required this.title,
    required this.originalPrice,
    required this.discountPrice,
    required this.rating,
    required this.ratingCount,
    this.isSaved = false,
    this.isPromo = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => DetailProductPage());
      },
      child: Container(
        width: 150,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(imageUrl, height: 100),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_outline),
                )
              ],
            ),
            SizedBox(height: 5),
            () {
              if (isPromo) {
                return Column(children: [
                  Row(
                    children: [
                      Text(
                        originalPrice,
                        style: TextStyle(
                          fontSize: 12,
                          decoration: TextDecoration.lineThrough,
                          color: Colors.red,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        discountPrice,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ]);
              } else {
                return Row(
                  children: [
                    Text(
                      originalPrice,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    ),
                  ],
                );
              }
            }(),
            Row(
              children: [
                Icon(Icons.star, color: Colors.yellow, size: 14),
                Text(
                  '$rating ($ratingCount)',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
