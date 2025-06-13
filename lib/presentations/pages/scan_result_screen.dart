// import 'dart:convert';
import 'dart:io';
import 'package:cak_rawit/databases/db_helper.dart';
import 'package:cak_rawit/models/prediction_result.dart';
import 'package:cak_rawit/presentations/colors/app_colors.dart';
import 'package:cak_rawit/services/ml_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
// import 'package:flutter/services.dart';
// import 'package:image/image.dart' as img;
// import 'package:tflite_flutter/tflite_flutter.dart';

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

  Future<String> saveImagePermanently(File imageFile) async {
    final appDir = await getApplicationDocumentsDirectory();
    final uuid = Uuid().v4(); // Untuk memberi nama unik
    final savedImage = await imageFile.copy('${appDir.path}/$uuid.jpg');
    return savedImage.path;
  }

  Future<void> savePredictionResult({
    required BuildContext context,
    required String label,
    required double confidence,
    required double moisture,
    required String imagePath,
  }) async {
    try {
      final timestamp = DateFormat(
        'yyyy-MM-dd HH:mm:ss',
      ).format(DateTime.now());

      String imagePath = await saveImagePermanently(widget.selectedImageFile!);
      print("image path : ${imagePath}");
      // print("image path : ${widget.selectedImageFile!.path}");
      final result = PredictionResult(
        label: label,
        confidence: confidence,
        moisture: moisture,
        imagePath: imagePath,
        timestamp: timestamp,
      );

      await DBHelper().insertPrediction(result);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hasil prediksi berhasil disimpan!')),
      );
    } catch (e) {
      debugPrint('Gagal menyimpan hasil prediksi: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan hasil prediksi.')),
      );
    }
  }

  Future<void> processML() async {
    try {
      final file = widget.selectedImageFile!;
      final klasifikasiResult = await mlService.runClassification(file);
      final kadarAir = await mlService.runRegression(file);

      setState(() {
        resultLabel = klasifikasiResult.label;
        resultConfidence = klasifikasiResult.confidence;
        // kadarAirResult = "${kadarAir.toStringAsFixed(2)}%";
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
    print("hasil : ${resultLabel}");
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight =
        mediaQuery.size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    return PopScope(
      child: SafeArea(
        child: Scaffold(
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
          body: Padding(
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
                const SizedBox(height: 12),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Text(
                      resultLabel ?? 'Tidak diketahui',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                const SizedBox(height: 12),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Text(
                      'Akurasi: ${(resultConfidence ?? 0.0) * 100}%',
                      // .toStringAsFixed(2)
                    ),
                const SizedBox(height: 12),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Text(
                      'Kadar: ${(kadarAirResult)}',
                      // .toStringAsFixed(2)
                    ),
                ElevatedButton(
                  onPressed:
                      () => savePredictionResult(
                        context: context,
                        label: resultLabel!,
                        confidence: resultConfidence!,
                        moisture: kadarAirResult!,
                        imagePath: widget.selectedImageFile!.path,
                      ),
                  child: Text('Simpan Hasil Prediksi'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
