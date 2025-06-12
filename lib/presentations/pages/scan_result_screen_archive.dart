// import 'dart:io';
// import 'dart:math';
// import 'dart:typed_data';

// import 'package:cak_rawit/presentations/colors/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:image/image.dart' as img;
// import 'package:tflite_v2/tflite_v2.dart';

// class ScanResultScreenArchive extends StatefulWidget {
//   const ScanResultScreenArchive({super.key, required this.selectedImageFile});
//   final File? selectedImageFile;

//   @override
//   State<ScanResultScreenArchive> createState() =>
//       _ScanResultScreenArchiveState();
// }

// class _ScanResultScreenArchiveState extends State<ScanResultScreenArchive> {
//   String? resultLabel;
//   double? resultConfidence;
//   String? kadarAirResult;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     // _runModelThenRegresi();
//     // _runModel();
//     _runRegresiModel();
//   }

//   // Future<void> _runModelThenRegresi() async {
//   // await Tflite.close(); // Tutup interpreter kalau ada sisa

//   // // Delay kecil untuk memastikan interpreter benar-benar tidak sibuk
//   // await Future.delayed(const Duration(milliseconds: 200));

//   // await _runModel(); // Jalankan klasifikasi dulu
//   // await Tflite.close(); // Tutup interpreter setelah klasifikasi
//   // await Future.delayed(const Duration(milliseconds: 200));
//   // await _runRegresiModel(); // Baru jalankan regresi

//   // setState(() {
//   //   isLoading = false;
//   // });
//   // }

//   // Future<Uint8List> _imageToByteListFloat32(
//   //   File imageFile,
//   //   int width,
//   //   int height,
//   // ) async {
//   //   final img.Image image = img.decodeImage(await imageFile.readAsBytes())!;
//   //   final resized = img.copyResize(image, width: width, height: height);

//   //   Float32List floatList = Float32List(width * height * 3);
//   //   int index = 0;

//   //   for (int y = 0; y < height; y++) {
//   //     for (int x = 0; x < width; x++) {
//   //       final pixel = resized.getPixel(x, y);
//   //       final r = pixel.r / 255.0;
//   //       final g = pixel.g / 255.0;
//   //       final b = pixel.b / 255.0;

//   //       floatList[index++] = r;
//   //       floatList[index++] = g;
//   //       floatList[index++] = b;
//   //     }
//   //   }

//   //   return floatList.buffer.asUint8List();
//   // }

//   // Future<void> _runRegresiModel() async {
//   //   await Tflite.close();
//   //   // Load model regresi
//   //   await Tflite.loadModel(
//   //     model: "assets/model/model_kadar_air.tflite",
//   //     isAsset: true,
//   //     useGpuDelegate: false,
//   //   );

//   //   // Konversi gambar ke ByteBuffer dengan ukuran & normalisasi sesuai
//   //   final imageBytes = await _imageToByteListFloat32(
//   //     File(widget.selectedImageFile!.path),
//   //     224,
//   //     224,
//   //   );

//   //   // Jalankan inference
//   //   final output = await Tflite.runModelOnImage(
//   //     path: widget.selectedImageFile!.path,
//   //     imageMean: 0.0,
//   //     imageStd: 255.0, // Sesuai normalisasi di Python
//   //     numResults: 1,
//   //     threshold: 0.0, // Tidak perlu threshold untuk regresi
//   //     asynch: true,
//   //   );

//   //   print("Output mentah: $output");

//   //   if (output != null && output.isNotEmpty) {
//   //     final predictedValue =
//   //         output.first["confidence"]; // biasaya nilai regresi ada di sini
//   //     final maxKadarAir = 91.0;
//   //     final kadarAir = predictedValue * maxKadarAir;

//   //     print("Prediksi kadar air: ${kadarAir.toStringAsFixed(2)}%");
//   //   } else {
//   //     print("Gagal mendeteksi kadar air.");
//   //   }

//   //   await Tflite.close();
//   // }

//   Future<void> _runModel() async {
//     // Load the model
//     await Tflite.loadModel(
//       model: "assets/model/coba_model_mobilenet.tflite",
//       labels: "assets/model/labels.txt", // Jika tidak ada, hapus parameter ini
//       numThreads: 1,
//       isAsset: true,
//       useGpuDelegate: false,
//     );

//     // Run prediction
//     final recognitions = await Tflite.runModelOnImage(
//       path: widget.selectedImageFile!.path,
//       numResults: 6,
//       threshold: 0.1,
//       imageMean: 127.5,
//       imageStd: 127.5,
//       // imageMean: 0,
//       // imageStd: 255.0,
//       asynch: true,
//     );

//     if (recognitions != null && recognitions.isNotEmpty) {
//       setState(() {
//         resultLabel = recognitions.first['label'];
//         resultConfidence = recognitions.first['confidence'];
//         isLoading = false;
//       });
//     } else {
//       setState(() {
//         resultLabel = 'Tidak terdeteksi';
//         resultConfidence = 0.0;
//         isLoading = false;
//       });
//     }
//     // await Tflite.close();
//   }

//   Future<void> _runRegresiModel() async {
//     await Tflite.loadModel(
//       model: "assets/model/model_kadar_air.tflite",
//       isAsset: true,
//       useGpuDelegate: false,
//     );

//     final output = await Tflite.runModelOnImage(
//       path: widget.selectedImageFile!.path,
//       imageMean: 0.0,
//       imageStd: 255.0,
//       numResults: 1,
//       threshold: 0.0,
//       asynch: true,
//     );

//     if (output != null && output.isNotEmpty) {
//       final predictedValue = output.first["confidence"];
//       final maxKadarAir = 91.0;
//       final kadarAir = predictedValue * maxKadarAir;

//       setState(() {
//         kadarAirResult = "${kadarAir.toStringAsFixed(2)}%";
//       });

//       print("Prediksi kadar air: $kadarAirResult");
//     } else {
//       print("Gagal mendeteksi kadar air.");
//     }

//     await Tflite.close();
//   }

//   @override
//   void dispose() {
//     Tflite.close();
//     super.dispose();
//   }

//   Future<bool> _onBackPressed() async {
//     bool confirmExit = await showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('try_another_detection'),
//           content: Text('do_you_want_to_try_another_detection'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context, true),
//               child: Text(
//                 'yes',
//                 style: TextStyle(color: Color(int.parse("0xff119646"))),
//               ),
//             ),
//             TextButton(
//               onPressed: () => Navigator.pop(context, false),
//               child: Text(
//                 'no',
//                 style: TextStyle(color: Color(int.parse("0xff119646"))),
//               ),
//             ),
//           ],
//         );
//       },
//     );

//     if (confirmExit ?? false) {
//       Navigator.pop(context);
//     }
//     return false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     print("hasil : ${resultLabel}");
//     final mediaQuery = MediaQuery.of(context);
//     final screenWidth = mediaQuery.size.width;
//     final screenHeight =
//         mediaQuery.size.height -
//         MediaQuery.of(context).padding.top -
//         kToolbarHeight;
//     return PopScope(
//       child: SafeArea(
//         child: Scaffold(
//           appBar: AppBar(
//             iconTheme: IconThemeData(color: Colors.white),
//             title: Text(
//               'Hasil kualitas',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w500,
//                 letterSpacing: 1,
//               ),
//             ),
//             backgroundColor: appColor.primaryColorGreen,
//           ),
//           body: Padding(
//             padding: EdgeInsets.symmetric(
//               horizontal: screenWidth * 0.15,
//               vertical: screenHeight * 0.1,
//             ),
//             child: Column(
//               children: [
//                 Center(
//                   child: Container(
//                     width: screenWidth * 0.7,
//                     height: screenWidth * 0.7,
//                     clipBehavior: Clip.antiAlias,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[400],
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(
//                         color: appColor.primaryColorGreen,
//                         width: 2,
//                       ),
//                       image: DecorationImage(
//                         image: FileImage(widget.selectedImageFile!),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                 ),
//                 // isLoading
//                 //     ? const Center(child: CircularProgressIndicator())
//                 //     : Text(
//                 //       resultLabel ?? 'Tidak diketahui',
//                 //       style: const TextStyle(
//                 //         fontSize: 24,
//                 //         fontWeight: FontWeight.bold,
//                 //         color: Colors.green,
//                 //       ),
//                 //     ),
//                 // const SizedBox(height: 12),
//                 // isLoading
//                 //     ? const Center(child: CircularProgressIndicator())
//                 //     : Text(
//                 //       'Akurasi: ${(resultConfidence ?? 0.0) * 100}%',
//                 //       // .toStringAsFixed(2)
//                 //     ),
//                 const SizedBox(height: 12),
//                 isLoading
//                     ? const Center(child: CircularProgressIndicator())
//                     : Text(
//                       'Akurasi: ${(kadarAirResult)}%',
//                       // .toStringAsFixed(2)
//                     ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
