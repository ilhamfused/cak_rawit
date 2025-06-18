import 'dart:io';

import 'package:cak_rawit/databases/db_helper.dart';
import 'package:cak_rawit/models/prediction_result.dart';
import 'package:cak_rawit/presentations/colors/app_colors.dart';
import 'package:cak_rawit/services/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<PredictionResult>> _predictionList;

  @override
  void initState() {
    super.initState();
    _predictionList = DBHelper().getPredictions();
  }

  String formatDate(String timestamp) {
    try {
      final date = DateFormat('yyyy-MM-dd HH:mm:ss').parse(timestamp);
      return DateFormat('dd MMM yyyy, HH:mm').format(date);
    } catch (e) {
      return timestamp;
    }
  }

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
            'Riwayat deteksi',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
            ),
          ),
          backgroundColor: appColor.primaryColorGreen,
        ),
        body: FutureBuilder<List<PredictionResult>>(
          future: _predictionList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Belum ada riwayat prediksi.'));
            }

            final predictions = snapshot.data!;

            return ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.025,
                vertical: screenWidth * 0.025,
              ),
              itemCount: predictions.length,
              itemBuilder: (context, index) {
                final result = predictions[index];
                return Card(
                  color: Colors.grey[50],
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(File(result.imagePath)),
                          fit: BoxFit.cover,
                          onError:
                              (error, stackTrace) => Icon(Icons.broken_image),
                        ),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: appColor.primaryColorGreen,
                          width: 1,
                        ),
                      ),
                      // Image.file(
                      //   File(result.imagePath),
                      //   width: 50,
                      //   height: 50,
                      //   fit: BoxFit.cover,
                      //   errorBuilder:
                      //       (context, error, stackTrace) =>
                      //           Icon(Icons.broken_image),
                      // ),
                    ),
                    title: Text(
                      result.label
                          .split('_')
                          .map((word) => toBeginningOfSentenceCase(word))
                          .join(' '),
                      style: TextStyle(
                        color: HelperFunction().textLabelColor(result.label),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Confidence: ${(result.confidence).toStringAsFixed(2)}%',
                        ),
                        Text(
                          'Kadar air: ${result.moisture.toStringAsFixed(2)}%',
                        ),
                        Text('Waktu: ${formatDate(result.timestamp)}'),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
