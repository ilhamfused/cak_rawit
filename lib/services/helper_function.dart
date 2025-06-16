import 'dart:io';

import 'package:cak_rawit/databases/db_helper.dart';
import 'package:cak_rawit/models/prediction_result.dart';
import 'package:cak_rawit/presentations/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class HelperFunction {
  final Map<String, String> labelMessage = {
    'segar':
        'Cabai kategori segar dengan kadar air di atas 45%. Cabai segar dapat langsung digunakan untuk keperluan sehari-hari atau dapat langsung dipasarkan',
    'sedang':
        'Cabai kategori sedang dengan kadar air di antara 11% dan 45%. Lebih baik cabai ini diolah menjadi cabai kering. Lihat informasi tentang pengolahan cabai kering',
    'kering':
        'Cabai kategori kering dengan kadar air di bawah 11%. Cabai kering dapat memiliki umur simpan yang lebih lama.Dapat langsung dikemas dan langsung dipasarkan',
  };

  String? createLabelMessage(String resultLabel) {
    if (resultLabel == 'merah_segar' || resultLabel == 'hijau_segar') {
      return labelMessage['segar'];
    } else if (resultLabel == 'merah_sedang' || resultLabel == 'hijau_sedang') {
      return labelMessage['sedang'];
    } else if (resultLabel == 'merah_kering' || resultLabel == 'hijau_kering') {
      return labelMessage['kering'];
    }
    return 'tidak terdeksi';
  }

  Color textLabelColor(String resultLabel) {
    if (resultLabel == 'merah_segar' || resultLabel == 'hijau_segar') {
      return appColor.textColorGreen2;
    } else if (resultLabel == 'merah_sedang' || resultLabel == 'hijau_sedang') {
      return appColor.primaryColorYellow;
    } else if (resultLabel == 'merah_kering' || resultLabel == 'hijau_kering') {
      return appColor.primaryColorRed;
    }
    return appColor.textColorGreen;
  }

  Color progressBarColor(double value) {
    if (value >= 40) {
      return appColor.textColorGreen2;
    } else if (value > 11 && value < 40) {
      return appColor.primaryColorYellow;
    } else if (value <= 11) {
      return appColor.primaryColorRed;
    }
    return appColor.textColorGreen;
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
    required File imageFile,
  }) async {
    try {
      final timestamp = DateFormat(
        'yyyy-MM-dd HH:mm:ss',
      ).format(DateTime.now());

      String imagePath = await HelperFunction().saveImagePermanently(imageFile);
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
}
