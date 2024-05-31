import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailProductPage extends StatelessWidget {
  const DetailProductPage({super.key});

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
      body: ProductDetail(),
    );
  }
}

class ProductDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                'https://images.tokopedia.net/img/cache/900/hDjmkQ/2024/5/20/c0a21724-f311-490b-9bf4-425d528e2a7b.jpg',
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
                    Text('4.7',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Spacer(),
                    Icon(Icons.bookmark_border, size: 30),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Jaco Joint Care Alat Terapi Lutut Kaki',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Rp 1.592.000',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Rp 3.980.000',
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
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Deskripsi :',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Joint Care adalah alat terapi untuk membantu mengatasi masalah nyeri lutut. Sinar Infra merah pada alat dapat melancarkan sistem peredaran darah. Terdapat vibratory yang berfungsi untuk memijat titik akupunktur pada lutut sehingga dapat merelaksasi lutut, mengurangi rasa sakit, kaku, dan tegangan pada sendi.',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'KEUNGGULAN JOINT CARE :',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  '1. Mudah digunakan.\n'
                  '2. Bisa digunakan oleh remaja sampai lansia.\n'
                  '3. Dilengkapi getaran untuk relaksasi lutut.\n'
                  '4. Bisa digunakan untuk tangan atau pinggang.\n'
                  '5. Terdapat sinar infrared yang bekerja pada bagian tubuh yang sakit akibat kecelakaan.',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: ElevatedButton(
                    onPressed: () {}, child: Text("Tambah ke keranjang")),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
