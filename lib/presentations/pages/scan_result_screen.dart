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
  const ScanResultScreen({
    super.key,
    required this.selectedImageFile,
    required this.resultLabel,
    required this.resultConfidence,
    required this.kadarAirResult,
  });
  final File? selectedImageFile;
  final String? resultLabel;
  final double? resultConfidence;
  final double? kadarAirResult;

  @override
  State<ScanResultScreen> createState() => _ScanResultScreenState();
}

class _ScanResultScreenState extends State<ScanResultScreen> {
  bool isLoading = false;

  final mlService = MLService();

  @override
  void initState() {
    super.initState();
    // processML();
  }

  // Future<void> processML() async {
  //   try {
  //     final file = widget.selectedImageFile!;
  //     final klasifikasiResult = await mlService.runClassification(file);
  //     final kadarAir = await mlService.runRegression(
  //       file,
  //       klasifikasiResult.label,
  //     );

  //     setState(() {
  //       resultLabel = klasifikasiResult.label;
  //       resultConfidence = (klasifikasiResult.confidence) * 100;
  //       kadarAirResult = kadarAir;
  //       isLoading = false;
  //     });
  //     print("label : " + resultLabel!);
  //     print("confidence : $resultConfidence!");
  //     print("kadar air :  $kadarAirResult");
  //   } catch (e) {
  //     print("Gagal memproses ML: $e");
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
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
      onPopInvokedWithResult: (didPop, result) async {
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
                      child: Text(
                        'Tidak',
                        style: TextStyle(color: appColor.primaryColorRed),
                      ),
                    ),
                    TextButton(
                      onPressed:
                          () =>
                              Navigator.of(context).pop(true), // Lanjut kembali
                      child: Text(
                        'Ya',
                        style: TextStyle(color: appColor.primaryColorGreen),
                      ),
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
                        HelperFunction().setLabel(widget.resultLabel!),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: HelperFunction().textLabelColor(
                            widget.resultLabel!,
                          ),
                        ),
                      ),

                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : widget.resultLabel! != 'random'
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
                            value: widget.kadarAirResult!,
                            color: HelperFunction().progressBarColor(
                              widget.kadarAirResult!,
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
                            value: widget.resultConfidence!,
                            color: HelperFunction().progressBarColor(
                              widget.resultConfidence!,
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
                          HelperFunction().createLabelMessage(
                            widget.resultLabel!,
                          )!,
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
                            label: widget.resultLabel!,
                            confidence: widget.resultConfidence!,
                            moisture: widget.kadarAirResult!,
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
