// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class OnboardingItem {
  final String image;
  final String title;
  final String shortDescription;
  OnboardingItem({
    required this.image,
    required this.title,
    required this.shortDescription,
  });


  OnboardingItem copyWith({
    String? image,
    String? title,
    String? shortDescription,
  }) {
    return OnboardingItem(
      image: image ?? this.image,
      title: title ?? this.title,
      shortDescription: shortDescription ?? this.shortDescription,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'image': image,
      'title': title,
      'shortDescription': shortDescription,
    };
  }

  factory OnboardingItem.fromMap(Map<String, dynamic> map) {
    return OnboardingItem(
      image: map['image'] as String,
      title: map['title'] as String,
      shortDescription: map['shortDescription'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory OnboardingItem.fromJson(String source) => OnboardingItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'OnboardingItem(image: $image, title: $title, shortDescription: $shortDescription)';

  @override
  bool operator ==(covariant OnboardingItem other) {
    if (identical(this, other)) return true;

    return
      other.image == image &&
          other.title == title &&
          other.shortDescription == shortDescription;
  }

  @override
  int get hashCode => image.hashCode ^ title.hashCode ^ shortDescription.hashCode;
}
