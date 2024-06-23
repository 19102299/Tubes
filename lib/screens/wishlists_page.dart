import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surgakicare/components/card.dart';
import 'package:surgakicare/services/auth_service.dart';
import 'package:surgakicare/services/saved_service.dart';
import 'package:surgakicare/tools/currecy_formatter.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Daftar Wishlists"),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 16,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wishlists(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Wishlists extends StatefulWidget {
  const Wishlists({super.key});

  @override
  State<Wishlists> createState() => _WishlistsState();
}

class _WishlistsState extends State<Wishlists> {
  @override
  void initState() {
    // TODO: implement initState
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
  }

  late final Stream<QuerySnapshot> _productsStream;

  late final Stream<DocumentSnapshot> _savedStream;

  var saved = [];

  final SavedService savedService = SavedService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
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

        var savedProducts = snapshot.data!.docs.where((e) {
          return saved.contains(e.id);
        }).toList();

        if (savedProducts.isEmpty) {
          return const Center(
            child: Text("Tidak ada wishlist"),
          );
        }

        return GridView.builder(
          itemCount: savedProducts.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            mainAxisExtent: 300,
          ),
          itemBuilder: (context, index) {
            var e = savedProducts[index].data() as Map<String, dynamic>;
            return ProductCard(
              imageUrl: e['imgurl'].toString(),
              title: e['title'].toString(),
              originalPrice: formatCurrency.format(e['originalprice']),
              discountPrice: formatCurrency.format(e['discountprice']),
              rating: double.parse(e['rating'].toString()),
              ratingCount: int.parse(
                e['ratingcount'].toString(),
              ),
              isPromo: e['ispromo'].toString() == "true" ? true : false,
              isSaved: true,
              onClickSaved: () {
                savedService.setSaved(savedProducts[index].id, false);
              },
              id: savedProducts[index].id,
            );
          },
        );
      },
    );
  }
}
