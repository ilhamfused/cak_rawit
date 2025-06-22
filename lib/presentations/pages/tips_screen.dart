import 'dart:convert';

import 'package:cak_rawit/models/tips.dart';
import 'package:cak_rawit/presentations/colors/app_colors.dart';
import 'package:cak_rawit/presentations/pages/home_screen.dart';
import 'package:cak_rawit/presentations/pages/tips_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TipsScreen extends StatefulWidget {
  const TipsScreen({super.key});

  @override
  State<TipsScreen> createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen> {
  late Future<List<Tips>> _tipsList;

  Future<List<Tips>> loadTips() async {
    final String response = await rootBundle.loadString(
      'assets/data/tips.json',
    );
    final List<dynamic> data = json.decode(response);
    return data.map((item) => Tips.fromMap(item)).toList();
  }

  @override
  void initState() {
    super.initState();
    _tipsList = loadTips();
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
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false,
        );
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: appColor.bgColorGreen,
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            title: Text(
              'Tips Seputar Cabai',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                letterSpacing: 1,
              ),
            ),
            backgroundColor: appColor.primaryColorGreen,
          ),
          body: FutureBuilder<List<Tips>>(
            future: _tipsList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                print(snapshot.hasError);
                return Center(child: Text("Terjadi kesalahan"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text("Belum ada tips"));
              } else {
                final tips = snapshot.data!;
                return ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.025,
                    vertical: screenWidth * 0.025,
                  ),
                  itemCount: tips.length,
                  itemBuilder: (context, index) {
                    final item = tips[index];
                    return Card(
                      color: Colors.grey[50],
                      margin: const EdgeInsets.all(8),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.025,
                          vertical: screenWidth * 0.05,
                        ),
                        child: ListTile(
                          leading: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(item.imagePath),
                                fit: BoxFit.cover,
                                onError:
                                    (error, stackTrace) =>
                                        Icon(Icons.broken_image),
                              ),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: appColor.primaryColorGreen,
                                width: 1,
                              ),
                            ),
                          ),
                          title: Text(item.title),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TipsDetailScreen(tips: item),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
