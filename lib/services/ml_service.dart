import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cak_rawit/services/helper_function.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class ClassificationResult {
  final String label;
  final double confidence;
  ClassificationResult(this.label, this.confidence);
}

class MLService {
  static final MLService _instance = MLService._internal();
  factory MLService() => _instance;
  MLService._internal();

  late Interpreter _classifier;
  late Interpreter _regressor;
  late List<String> _labels;
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    _classifier = await Interpreter.fromAsset(
      'assets/model/mobilenetv2_cabai_7kelas.tflite',
    );
    _regressor = await Interpreter.fromAsset(
      'assets/model/model_kadar_air_2.tflite',
    );

    final raw = await rootBundle.loadString('assets/model/labels.txt');
    _labels = LineSplitter.split(raw).toList();

    _isInitialized = true;
  }

  Future<ClassificationResult> runClassification(File imageFile) async {
    if (!_isInitialized) {
      throw Exception("MLService belum diinisialisasi");
    }

    final rawImage = img.decodeImage(imageFile.readAsBytesSync());
    final inputSize = _classifier.getInputTensor(0).shape[1];

    final resizedImage = img.copyResize(
      rawImage!,
      width: inputSize,
      height: inputSize,
    );
    final input = List.generate(inputSize, (y) {
      return List.generate(inputSize, (x) {
        final pixel = resizedImage.getPixel(x, y);
        return [
          img.getRed(pixel) / 255.0,
          img.getGreen(pixel) / 255.0,
          img.getBlue(pixel) / 255.0,
        ];
      });
    });

    final output = List.generate(1, (_) => List.filled(_labels.length, 0.0));
    _classifier.run([input], output);

    final probs = output[0];
    final maxIndex = probs.indexWhere(
      (p) => p == probs.reduce((a, b) => a > b ? a : b),
    );
    return ClassificationResult(_labels[maxIndex], probs[maxIndex]);
  }

  Future<double> runRegression(File imageFile, String label) async {
    if (!_isInitialized) {
      throw Exception("MLService belum diinisialisasi");
    }

    final imageRaw = img.decodeImage(imageFile.readAsBytesSync());
    final inputSize = _regressor.getInputTensor(0).shape[1];
    final resizedImage = img.copyResize(
      imageRaw!,
      width: inputSize,
      height: inputSize,
    );

    final input = List.generate(
      1,
      (_) => List.generate(inputSize, (y) {
        return List.generate(inputSize, (x) {
          final pixel = resizedImage.getPixel(x, y);
          return [
            img.getRed(pixel) / 255.0,
            img.getGreen(pixel) / 255.0,
            img.getBlue(pixel) / 255.0,
          ];
        });
      }),
    );

    final output = List.generate(1, (_) => List.filled(1, 0.0));
    _regressor.run(input, output);
    // const maxKadarAir = 91.0;
    final outputRegressor = HelperFunction().normalize(output[0][0], label);
    return outputRegressor;
  }
}
