import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surgakicare/controllers/account_controller.dart';
import 'package:surgakicare/main.dart';
import 'package:surgakicare/screens/login.dart';
import 'package:surgakicare/services/auth_service.dart';

class AccountPage extends StatelessWidget {
  AccountPage({
    Key? key,
  }) : super(key: key);

  void logout() async {
    Get.delete<AccountController>();
    await AuthService().signOut();
    Get.off(() => LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    final AccountController c = Get.put(AccountController());
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20),
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Obx(
                () => Text(
                  "${c.name.value}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              SizedBox(height: 5),
              Obx(
                () => Text(
                  "${c.email.value}",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              SizedBox(height: 5),
              Obx(
                () => Text(
                  "Terdaftar : ${c.tanggaldaftar.value}",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              SizedBox(height: 20),
              ListTile(
                title: Text('Wishlists'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {},
              ),
              ListTile(
                title: Text('Detail Akun'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {},
              ),
              ListTile(
                title: Text('Lihat Pesanan Saya'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {},
              ),
              ListTile(
                title: Text('Logout'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  logout();
                  Get.off(() => StartScreen());
                },
              ),
              SizedBox(
                height: 24,
              ),
              Text(
                'Notice :',
                style: TextStyle(color: Colors.grey),
              ),
              Text(
                'Project ini merupakan tugas\nPemrograman Perangkat Penggerak',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 10),
              Text(
                'TEKNIK INFORMATIKA\nINSTITUT TEKNOLOGI TELKOM PURWOKERTO\nBANYUMAS, JAWA TENGAH\n2024',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
