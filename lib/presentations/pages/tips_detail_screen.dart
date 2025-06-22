import 'package:cak_rawit/models/tips.dart';
import 'package:cak_rawit/presentations/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class TipsDetailScreen extends StatelessWidget {
  final Tips tips;

  const TipsDetailScreen({super.key, required this.tips});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    return Scaffold(
      backgroundColor: appColor.bgColorGreen,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          tips.title,
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
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                tips.imagePath,
                width: screenWidth,
                fit: BoxFit.cover,
              ),
              SizedBox(height: screenWidth * 0.05),
              Html(
                data: tips.post,
                style: {
                  "h1": Style(fontSize: FontSize.xxLarge),
                  "h2": Style(fontSize: FontSize.xLarge),
                  "p": Style(fontSize: FontSize.medium),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
