import 'package:cak_rawit/presentations/colors/app_colors.dart';
import 'package:flutter/material.dart';

class TutorialScreen extends StatelessWidget {
  const TutorialScreen({super.key});

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
            'Panduan Penggunaan',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
            ),
          ),
          backgroundColor: appColor.primaryColorGreen,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/tutorial.png',
                    width: screenWidth * 0.8,
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.1),
              Text(
                "1. Buka menu 'Cek Kualitas Cabai'\n\n2. Di halaman pengecekan anda memiliki 2 pilihan. Yaitu mengupload foto langsung dari kamera, atau mengupload foto dari galeri\n\n3. Setelah anda memilih gambar klik 'Cek Kualitas Cabai'\n\n4. Selamat anda berhasil mengetahui kualitas cabai beserta kadar air yang terkandung di dalam cabai dan akurasi dari model. Anda bisa memilih opsi 'Simpan Hasil Prediksi' jika Anda mau.",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
