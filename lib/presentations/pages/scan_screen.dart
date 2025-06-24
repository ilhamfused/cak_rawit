import 'dart:io';

import 'package:cak_rawit/presentations/colors/app_colors.dart';
import 'package:cak_rawit/presentations/pages/scan_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  File? selectedImageFile;

  Future<File?> _imgFromGallery(BuildContext context) async {
    final picker = ImagePicker();
    XFile? imageFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );

    if (imageFile != "null" && imageFile != null) {
      setState(() {
        selectedImageFile = File(
          imageFile.path,
        ); // Store the selected image file
      });
      return File(imageFile.path);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Belum memilih gambar')));
      }
    }

    return null;
  }

  Future<File?> _imgFromCamera(BuildContext context) async {
    final picker = ImagePicker();
    XFile? imageFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 100,
    );

    if (imageFile != "null" && imageFile != null) {
      setState(() {
        selectedImageFile = File(
          imageFile.path,
        ); // Store the selected image file
      });
      return File(imageFile.path);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Belum memilih gambar')));
      }
    }
    return null;
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
            'Cek Kualitas Cabai',
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
                child: SizedBox(
                  width: screenWidth * 0.7,
                  height: screenWidth * 0.7,
                  child:
                      selectedImageFile != null
                          ? Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: appColor.primaryColorGreen,
                                width: 2,
                              ),
                              image: DecorationImage(
                                image: FileImage(selectedImageFile!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                          : Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: appColor.primaryColorGreen,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image,
                                  color: Colors.white,
                                  size: screenWidth * 0.25,
                                ),
                                SizedBox(height: screenHeight * 0.04),
                                Text(
                                  'Gambar Kosong',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                ),
              ),
              SizedBox(height: screenHeight * 0.07),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      _imgFromCamera(context);
                    },
                    child: Container(
                      width: screenWidth * 0.325,
                      height: screenHeight * 0.1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade500,
                            spreadRadius: 0,
                            blurRadius: 2,
                            offset: Offset(0, 2),
                          ),
                        ],
                        color: appColor.secondaryColorGreen,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: screenWidth * 0.02,
                        children: [
                          Icon(
                            Icons.camera_alt,
                            color: appColor.textColorGreen,
                            size: 26,
                          ),
                          Text(
                            'Ambil Foto',
                            style: TextStyle(
                              color: appColor.textColorGreen,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _imgFromGallery(context);
                    },
                    child: Container(
                      width: screenWidth * 0.325,
                      height: screenHeight * 0.1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade500,
                            spreadRadius: 0,
                            blurRadius: 2,
                            offset: Offset(0, 2),
                          ),
                        ],
                        color: appColor.secondaryColorGreen,
                      ),
                      child: Center(
                        child: Row(
                          spacing: screenWidth * 0.02,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.photo_library_outlined,
                              color: appColor.textColorGreen,
                              size: 26,
                            ),
                            Text(
                              'Buka Galeri',
                              style: TextStyle(
                                color: appColor.textColorGreen,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.035),
              GestureDetector(
                onTap:
                    selectedImageFile != null
                        ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ScanResultScreen(
                                  selectedImageFile: selectedImageFile,
                                );
                              },
                            ),
                          );
                        }
                        : null,
                child: Container(
                  height: screenHeight * 0.1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade500,
                        spreadRadius: 0,
                        blurRadius: 2,
                        offset: Offset(0, 2),
                      ),
                    ],
                    color:
                        selectedImageFile != null
                            ? appColor.primaryColorRed
                            : Colors.grey,
                  ),
                  child: Center(
                    child: Row(
                      spacing: screenWidth * 0.02,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.auto_awesome_sharp,
                          color: Colors.white,
                          size: 26,
                        ),
                        Text(
                          'Cek Kualitas Cabai',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
