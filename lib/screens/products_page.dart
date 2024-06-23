import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rxdart/rxdart.dart';
import 'package:surgakicare/components/card.dart';
import 'package:surgakicare/services/auth_service.dart';
import 'package:surgakicare/services/saved_service.dart';
import 'package:surgakicare/tools/currecy_formatter.dart';

class ProductPage extends StatefulWidget {
  ProductPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  TextEditingController searchController = TextEditingController();
  String textSearch = "";

  Stream<QuerySnapshot>? _productsStream;

  late final Stream<DocumentSnapshot> _savedStream;

  var saved = [];

  final SavedService savedService = SavedService();

  @override
  void initState() {
    super.initState();

    var service = AuthService();
    var user = service.getCurrentUser();
    _productsStream =
        FirebaseFirestore.instance.collection('products').snapshots();

    _savedStream = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .snapshots();

    _savedStream.listen(
      (event) {
        var data = event.data() as Map<String, dynamic>;
        saved = data['wishlists'];
        setState(() {});
      },
    );

    searchController.addListener(() {
      setState(() {
        textSearch = searchController.text.trim();
        _productsStream = FirebaseFirestore.instance
            .collection('products')
            .where('title', isGreaterThanOrEqualTo: textSearch)
            .where('title', isLessThanOrEqualTo: textSearch + '\uf8ff')
            .snapshots();
        print(textSearch);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
                child: StreamBuilder(
                  stream: _productsStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text("Something went wrong");
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return GridView.builder(
                      itemCount: snapshot.data!.docs.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        mainAxisExtent: 300,
                      ),
                      itemBuilder: (context, index) {
                        var e = snapshot.data!.docs[index].data()
                            as Map<String, dynamic>;
                        return ProductCard(
                          imageUrl: e['imgurl'].toString(),
                          title: e['title'].toString(),
                          originalPrice:
                              formatCurrency.format(e['originalprice']),
                          discountPrice:
                              formatCurrency.format(e['discountprice']),
                          rating: double.parse(e['rating'].toString()),
                          ratingCount: int.parse(
                            e['ratingcount'].toString(),
                          ),
                          isPromo:
                              e['ispromo'].toString() == "true" ? true : false,
                          isSaved:
                              saved.contains(snapshot.data!.docs[index].id),
                          onClickSaved: () {
                            if (saved.contains(snapshot.data!.docs[index].id)) {
                              savedService.setSaved(
                                  snapshot.data!.docs[index].id, false);
                            } else {
                              savedService.setSaved(
                                  snapshot.data!.docs[index].id, true);
                            }
                          },
                          id: snapshot.data!.docs[index].id,
                        );
                      },
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
