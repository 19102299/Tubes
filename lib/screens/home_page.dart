import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surgakicare/components/card.dart';
import 'package:surgakicare/services/auth_service.dart';
import 'package:surgakicare/services/saved_service.dart';
import 'package:surgakicare/tools/currecy_formatter.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var productStream =
      FirebaseFirestore.instance.collection('products').snapshots();
  var saved = [];
  var savedStream = FirebaseFirestore.instance
      .collection('users')
      .doc(AuthService().getCurrentUser()!.uid)
      .snapshots();

  final SavedService savedService = SavedService();

  @override
  void initState() {
    super.initState();

    savedStream.listen(
      (event) {
        saved = event.data()!['wishlists'] as List;
        setState(() {});
      },
    );
  }

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
              StreamBuilder(
                stream: productStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text("Something went wrong");
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return CarouselSlider(
                    options: CarouselOptions(
                      height: 300,
                      enableInfiniteScroll: true,
                      viewportFraction: 0.5,
                      enlargeCenterPage: false,
                      autoPlay: true,
                    ),
                    items: snapshot.data!.docs.where((e) {
                      return e.data()['ispromo'].toString() == "true";
                    }).map((e) {
                      var z = e.data();
                      return ProductCard(
                        imageUrl: z['imgurl'].toString(),
                        title: z['title'].toString(),
                        originalPrice:
                            formatCurrency.format(z['originalprice']),
                        discountPrice:
                            formatCurrency.format(z['discountprice']),
                        rating: double.parse(
                          z['rating'].toString(),
                        ),
                        ratingCount: int.parse(
                          z['ratingcount'].toString(),
                        ),
                        isPromo: e['ispromo'].toString() == "true",
                        onClickSaved: () {
                          if (saved.contains(e.id)) {
                            savedService.setSaved(e.id, false);
                          } else {
                            savedService.setSaved(e.id, true);
                          }
                        },
                        isSaved: saved.contains(e.id),
                        id: e.id,
                      );
                    }).toList(),
                  );
                },
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
              StreamBuilder(
                stream: productStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text("Something went wrong");
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  snapshot.data!.docs.sort((a, b) {
                    return double.parse(a.data()['rating'].toString())
                        .compareTo(double.parse(b.data()['rating'].toString()));
                  });

                  return CarouselSlider(
                    options: CarouselOptions(
                      height: 300,
                      enableInfiniteScroll: true,
                      viewportFraction: 0.5,
                      enlargeCenterPage: false,
                      autoPlay: true,
                    ),
                    items: snapshot.data!.docs.map((e) {
                      var z = e.data();
                      return ProductCard(
                        imageUrl: z['imgurl'].toString(),
                        title: z['title'].toString(),
                        originalPrice:
                            formatCurrency.format(z['originalprice']),
                        discountPrice:
                            formatCurrency.format(z['discountprice']),
                        rating: double.parse(
                          z['rating'].toString(),
                        ),
                        ratingCount: int.parse(
                          z['ratingcount'].toString(),
                        ),
                        isPromo: e['ispromo'].toString() == "true",
                        onClickSaved: () {
                          if (saved.contains(e.id)) {
                            savedService.setSaved(e.id, false);
                          } else {
                            savedService.setSaved(e.id, true);
                          }
                        },
                        isSaved: saved.contains(e.id),
                        id: e.id,
                      );
                    }).toList(),
                  );
                },
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
