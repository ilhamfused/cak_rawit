import 'dart:io';
import 'package:cak_rawit/presentations/colors/app_colors.dart';
import 'package:cak_rawit/presentations/pages/home_screen.dart';
import 'package:cak_rawit/presentations/pages/tips_screen.dart';
import 'package:cak_rawit/presentations/widgets/custom_progress_bar.dart';
import 'package:cak_rawit/services/helper_function.dart';
import 'package:cak_rawit/services/ml_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScanResultScreen extends StatefulWidget {
  const ScanResultScreen({super.key, required this.selectedImageFile});
  final File? selectedImageFile;

  @override
  State<ScanResultScreen> createState() => _ScanResultScreenState();
}

class _ScanResultScreenState extends State<ScanResultScreen> {
  String? resultLabel;
  double? resultConfidence;
  double? kadarAirResult;
  bool isLoading = true;

  final mlService = MLService();

  @override
  void initState() {
    super.initState();
    processML();
  }

  Future<void> processML() async {
    try {
      final file = widget.selectedImageFile!;
      final klasifikasiResult = await mlService.runClassification(file);
      final kadarAir = await mlService.runRegression(
        file,
        klasifikasiResult.label,
      );

      setState(() {
        resultLabel = klasifikasiResult.label;
        resultConfidence = (klasifikasiResult.confidence) * 100;
        kadarAirResult = kadarAir;
        isLoading = false;
      });
      print("label : " + resultLabel!);
      print("confidence : $resultConfidence!");
      print("kadar air :  $kadarAirResult");
    } catch (e) {
      print("Gagal memproses ML: $e");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> _onBackPressed() async {
    bool confirmExit = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('try_another_detection'),
          content: Text('do_you_want_to_try_another_detection'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                'yes',
                style: TextStyle(color: Color(int.parse("0xff119646"))),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'no',
                style: TextStyle(color: Color(int.parse("0xff119646"))),
              ),
            ),
          ],
        );
      },
    );

    if (confirmExit ?? false) {
      Navigator.pop(context);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight =
        mediaQuery.size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    return PopScope(
      canPop: false, // Disable back button by default
      onPopInvoked: (didPop) async {
        if (!didPop) {
          final shouldPop = await showDialog<bool>(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: const Text('Konfirmasi'),
                  content: const Text(
                    'Apakah Anda yakin ingin kembali tanpa menyimpan hasil prediksi?',
                  ),
                  actions: [
                    TextButton(
                      onPressed:
                          () => Navigator.of(
                            context,
                          ).pop(false), // Tidak jadi kembali
                      child: const Text('Tidak'),
                    ),
                    TextButton(
                      onPressed:
                          () =>
                              Navigator.of(context).pop(true), // Lanjut kembali
                      child: const Text('Ya'),
                    ),
                  ],
                ),
          );

          if (shouldPop == true) {
            Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
          }
        }
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: appColor.bgColorGreen,
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            title: Text(
              'Hasil kualitas',
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
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.15,
                vertical: screenHeight * 0.1,
              ),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      width: screenWidth * 0.7,
                      height: screenWidth * 0.7,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: appColor.primaryColorGreen,
                          width: 2,
                        ),
                        image: DecorationImage(
                          image: FileImage(widget.selectedImageFile!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.03),
                  Text(
                    'Gambar Terdeteksi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: appColor.textColorGreen,
                    ),
                  ),
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Text(
                        HelperFunction().setLabel(resultLabel!),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: HelperFunction().textLabelColor(resultLabel!),
                        ),
                      ),

                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : resultLabel! != 'random'
                      ? (Column(
                        children: [
                          SizedBox(height: screenWidth * 0.03),
                          Text(
                            'Kadar Air',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: appColor.textColorGreen,
                            ),
                          ),
                          CustomProgressBar(
                            value: kadarAirResult!,
                            color: HelperFunction().progressBarColor(
                              kadarAirResult!,
                            ),
                          ),
                        ],
                      ))
                      : SizedBox(height: 0),
                  SizedBox(height: screenWidth * 0.03),
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                        children: [
                          Text(
                            'Akurasi Model',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: appColor.textColorGreen,
                            ),
                          ),
                          CustomProgressBar(
                            value: resultConfidence!,
                            color: HelperFunction().progressBarColor(
                              resultConfidence!,
                            ),
                          ),
                        ],
                      ),
                  SizedBox(height: screenWidth * 0.03),
                  SizedBox(
                    width: screenWidth * 0.7,
                    child: Card(
                      color: Colors.white,
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          HelperFunction().createLabelMessage(resultLabel!)!,
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.05),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(
                        color: appColor.primaryColorRed,
                        width: 2,
                      ),
                      backgroundColor: appColor.bgColorGreen,
                      fixedSize: Size(screenWidth * 0.7, screenHeight * 0.07),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed:
                        () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => TipsScreen()),
                        ),
                    child: Text(
                      'Cek Halaman Tips',
                      style: TextStyle(color: appColor.primaryColorRed),
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.03),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appColor.primaryColorRed,
                      fixedSize: Size(screenWidth * 0.7, screenHeight * 0.07),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed:
                        () => {
                          HelperFunction().savePredictionResult(
                            context: context,
                            label: resultLabel!,
                            confidence: resultConfidence!,
                            moisture: kadarAirResult!,
                            imagePath: widget.selectedImageFile!.path,
                            imageFile: widget.selectedImageFile!,
                          ),

                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
                            (route) => false,
                          ),
                        },
                    child: Text(
                      'Simpan Hasil Prediksi',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
