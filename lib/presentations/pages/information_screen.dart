import 'dart:convert';

import 'package:cak_rawit/presentations/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InformationScreen extends StatelessWidget {
  const InformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight =
        mediaQuery.size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    return SafeArea(
      child: Scaffold(
        backgroundColor: appColor.bgColorGreen,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            'Informasi Aplikasi',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
            ),
          ),
          backgroundColor: appColor.primaryColorGreen,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo-full.png',
                      height: screenWidth * 0.4,
                    ),
                  ],
                ),
                Text(
                  "Nama aplikasi Cak Rawit sebenarnya terinspirasi dari kata \"Cek Cabai Rawit\", namun kami memutuskan untuk bermain dengan kata sehingga lahirlah nama \"Cak Rawit\".\n\nAplikasi ini dikembangkan untuk membantu mengklasifikasikan kualitas cabai rawit berdasarkan kadar air yang terkandung di dalamnya. Dengan memanfaatkan teknologi pengolahan citra dan kecerdasan buatan.\n\nTujuan utama dari aplikasi ini adalah untuk memberikan solusi sederhana namun efektif bagi para petani, pedagang, maupun pelaku industri pengolahan cabai yang membutuhkan penilaian cepat terhadap kondisi cabai mereka. Dengan hanya menggunakan gambar, pengguna dapat mengetahui estimasi kadar air cabai tanpa perlu alat ukur khusus.\n\nKami berharap Cak Rawit dapat menjadi langkah awal menuju pertanian yang lebih cerdas dan efisien, sekaligus mendorong pemanfaatan teknologi di sektor pertanian lokal.",
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appColor.primaryColorGreen,
                        fixedSize: Size(screenWidth * 0.7, screenHeight * 0.07),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () => {},
                      child: Text(
                        'Panduan Penggunaan Aplikasi',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appColor.primaryColorGreen,
                        fixedSize: Size(screenWidth * 0.7, screenHeight * 0.07),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () => {},
                      child: Text(
                        'Hubungi Pengembang',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
