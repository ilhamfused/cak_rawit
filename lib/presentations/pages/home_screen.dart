import 'package:cak_rawit/presentations/colors/app_colors.dart';
import 'package:cak_rawit/presentations/pages/information_screen.dart';
import 'package:cak_rawit/presentations/pages/history_screen.dart';
import 'package:cak_rawit/presentations/pages/scan_screen.dart';
import 'package:cak_rawit/presentations/pages/tips_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _precacheImages();
  }

  Future<void> _precacheImages() async {
    await Future.wait([
      // precacheImage(Image.asset("assets/quality.png").image, context),
      // precacheImage(Image.asset("assets/bg_baru.png").image, context),
      // precacheImage(Image.asset("assets/deteksi.png").image, context),
      // precacheImage(Image.asset("assets/dokumen.png").image, context),
      // precacheImage(Image.asset("assets/lampu.png").image, context),
      // precacheImage(Image.asset("assets/info.png").image, context),
      // precacheImage(Image.asset("assets/distribusi.png").image, context),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    // final bodyHeight = screenHeight - myAppBar.preferredSize.height - MediaQuery.of(context).padding.top;
    return SafeArea(
      child: Scaffold(
        backgroundColor: appColor.bgColorGreen,
        body: Stack(
          children: [
            Container(
              height: screenHeight * 0.35,
              padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.02,
                horizontal: screenWidth * 0.05,
              ),
              color: appColor.primaryColorGreen,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight * 0.015),
                      const Text(
                        'Selamat Datang!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.005),
                      const Text(
                        'Semoga hari anda selalu menyenangkan.',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  Container(
                    // margin: EdgeInsets.symmetric(vertical: screenWidth * 0.025),
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.02,
                      horizontal: screenWidth * 0.05,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: appColor.secondaryColorGreen,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: Colors.grey.shade300, blurRadius: 8),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Solusi Cerdas Identifikasi Cabai Rawit',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        // const SizedBox(width: 16),
                        Image.asset(
                          'assets/images/cabai-rawit-merah-hijau-tumpuk2.png',
                          width: screenWidth * 0.225,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Container(
                margin: EdgeInsets.only(top: screenHeight * 0.295),
                child: Column(
                  children: [
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        padding: const EdgeInsets.all(10),
                        children: [
                          _buildMenuItem(
                            context,
                            "assets/images/menu-scan (2).svg",
                            // _localizedStrings[_selectedLanguage]!['cek_kualitas_cabai']!,
                            "Cek kualitas cabai",
                            ScanScreen(),
                          ),
                          _buildMenuItem(
                            context,
                            "assets/images/menu-history (2).svg",
                            "riwayat deteksi",
                            HistoryScreen(),
                          ),
                          _buildMenuItem(
                            context,
                            "assets/images/menu-tips (2).svg",
                            "Artikel seputar cabai",
                            TipsScreen(),
                          ),
                          _buildMenuItem(
                            context,
                            "assets/images/menu-tentang.svg",
                            "Informasi Aplikasi",
                            InformationScreen(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String imagePath,
    String title,
    Widget screen,
  ) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        child: Container(
          padding: EdgeInsets.all(screenWidth * 0.01),
          decoration: BoxDecoration(
            color: appColor.secondaryColorGreen,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                imagePath,
                width: MediaQuery.of(context).size.width * 0.2,
                // color: appColor.primaryColorGreen,
                colorFilter: ColorFilter.mode(
                  appColor.primaryColorGreen,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
