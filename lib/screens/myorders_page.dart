import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:surgakicare/services/auth_service.dart';
import 'package:surgakicare/tools/currecy_formatter.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  var myOrderStream = FirebaseFirestore.instance
      .collection('orders')
      .where('idPengguna', isEqualTo: AuthService().getCurrentUser()!.uid)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Daftar Pesanan Saya"),
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
                    child: StreamBuilder(
                      stream: myOrderStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Text("Something went wrong");
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var data = snapshot.data!.docs[index].data();
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Text(DateTime.fromMillisecondsSinceEpoch(
                                        data['timestamp'])
                                    .toString()),
                                subtitle: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    for (var element in data['carts'] as List)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Text(
                                          element['title'] +
                                              " X " +
                                              element['quantity'] +
                                              " = " +
                                              formatCurrency.format(
                                                  int.parse(element['price'])),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    Text(
                                      "Total : " +
                                          formatCurrency
                                              .format(data['totalprice']),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
