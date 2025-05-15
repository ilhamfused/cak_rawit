import 'package:cak_rawit/presentations/widgets/onboarding_item.dart';
import 'package:flutter/material.dart';

class OnboardingTemplate extends StatelessWidget {
  const OnboardingTemplate({super.key, required this.item});

  final OnboardingItem item;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Image.asset(item.image, height: size.height * 0.3),
        SizedBox(height: size.height * 0.05),
        FittedBox(
          child: Text(
            item.title,
            style: Theme.of(
              context,
            ).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(height: size.height * 0.02),
        Text(
          item.shortDescription,
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: size.height * 0.1),
      ],
    );
  }
}
