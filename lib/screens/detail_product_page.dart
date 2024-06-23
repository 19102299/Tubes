import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/sockets/src/sockets_io.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surgakicare/services/auth_service.dart';
import 'package:surgakicare/services/saved_service.dart';
import 'package:surgakicare/tools/currecy_formatter.dart';

class DetailProductPage extends StatelessWidget {
  String id;

  DetailProductPage(this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 35, 46, 142),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text(
          'Detail Produk',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: ProductDetail(id),
    );
  }
}

class ProductDetail extends StatefulWidget {
  String id;

  ProductDetail(this.id);

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  Stream<DocumentSnapshot>? _productDetailStream;

  late final Stream<DocumentSnapshot> _savedStream;

  var saved = [];

  SavedService savedService = SavedService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _productDetailStream = FirebaseFirestore.instance
        .collection('products')
        .doc(widget.id)
        .snapshots() as Stream<DocumentSnapshot<Object?>>?;

    _savedStream = FirebaseFirestore.instance
        .collection('users')
        .doc(AuthService().getCurrentUser()!.uid)
        .snapshots();

    _savedStream.listen(
      (event) {
        var data = event.data() as Map<String, dynamic>;
        saved = data['wishlists'];
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder(
        stream: _productDetailStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          var data = snapshot.data!.data() as Map<String, dynamic>;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    data['imgurl'],
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Icon(Icons.star, color: Colors.yellow, size: 30),
                        SizedBox(width: 5),
                        Text(data['rating'],
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        Spacer(),
                        IconButton(
                            onPressed: () {
                              if (saved.contains(widget.id)) {
                                savedService.setSaved(widget.id, false);
                              } else {
                                savedService.setSaved(widget.id, true);
                              }
                            },
                            icon: saved.contains(widget.id)
                                ? Icon(Icons.bookmark, size: 30)
                                : Icon(Icons.bookmark_border, size: 30))
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      data['title'],
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 5),
                  data['ispromo']
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    formatCurrency
                                        .format(data['discountprice']),
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    formatCurrency
                                        .format(data['originalprice']),
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    formatCurrency
                                        .format(data['originalprice']),
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Deskripsi :',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      data['description'],
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: ElevatedButton(
                        onPressed: () async {
                          try {
                            await FirebaseFirestore.instance
                                .collection('carts')
                                .add({
                              'idProduk': widget.id,
                              'idPengguna': AuthService().getCurrentUser()!.uid,
                              'imgurl': data['imgurl'],
                              'title': data['title'],
                              'price': data['ispromo']
                                  ? data['discountprice']
                                  : data['originalprice']
                            });

                            print("Data successfully written to Firestore!");
                          } catch (e) {
                            print("Error writing to Firestore: $e");
                          }
                          Get.back();
                        },
                        child: Text("Tambah ke keranjang")),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
