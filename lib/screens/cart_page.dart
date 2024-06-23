import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surgakicare/services/auth_service.dart';
import 'package:surgakicare/tools/currecy_formatter.dart';

class CartPage extends StatefulWidget {
  CartPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Stream<QuerySnapshot>? cartStream;

  var carts = [];

  var totalPrice = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    cartStream = FirebaseFirestore.instance
        .collection('carts')
        .where('idPengguna', isEqualTo: AuthService().getCurrentUser()!.uid)
        .snapshots();

    cartStream!.listen((event) {
      setState(() {
        totalPrice = 0;
      });
      event.docs.forEach((e) {
        var data = e.data() as Map<String, dynamic>;

        var z = Map<String, String>();
        z['imgurl'] = e['imgurl'];
        z['title'] = e['title'];
        z['price'] = e['price'].toString();
        z['quantity'] = "1";
        carts.add(z);

        totalPrice = totalPrice + data['price'] as int;
      });
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              StreamBuilder(
                stream: cartStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text("Something went wrong");
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data!.docs[index].data()
                          as Map<String, dynamic>;
                      return GestureDetector(
                        onLongPress: () async {
                          await FirebaseFirestore.instance
                              .collection('carts')
                              .doc(snapshot.data!.docs[index].id)
                              .delete();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CartItem(
                            imageUrl: data['imgurl'],
                            title: data['title'],
                            harga: data['price'],
                            quantity: 1,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 20),
              Text(
                'Total Belanjaan Anda :',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                formatCurrency.format(totalPrice),
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await FirebaseFirestore.instance.collection('orders').add({
                      'idPengguna': AuthService().getCurrentUser()!.uid,
                      'timestamp': DateTime.now().millisecondsSinceEpoch,
                      'carts': carts,
                      'totalprice': totalPrice,
                    });

                    print("Data successfully written to Firestore!");
                  } catch (e) {
                    print("Error writing to Firestore: $e");
                  }

                  var snapshot = await FirebaseFirestore.instance
                      .collection('carts')
                      .where('idPengguna',
                          isEqualTo: AuthService().getCurrentUser()!.uid)
                      .get();

                  for (var element in snapshot.docs) {
                    print(element);
                    await FirebaseFirestore.instance
                        .collection('carts')
                        .doc(element.id)
                        .delete();
                  }

                  // print("IDTODELETE");
                  // print(idToDelete);
                },
                child: Text('PROSES'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                  textStyle: TextStyle(fontSize: 16),
                ),
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
