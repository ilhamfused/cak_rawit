import 'package:flutter/material.dart';

class Tips {
  final int? id;
  final String title;
  final String post;
  final String imagePath;

  Tips({
    this.id,
    required this.title,
    required this.post,
    required this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'post': post, 'imagePath': imagePath};
  }

  factory Tips.fromMap(Map<String, dynamic> map) {
    return Tips(
      id: map['id'],
      title: map['title'],
      post: map['post'],
      imagePath: map['imagePath'],
    );
  }
}
