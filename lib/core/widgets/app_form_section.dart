import 'package:flutter/material.dart';

class AppFormSection extends StatelessWidget {
  final Widget child;

  const AppFormSection({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 18, top: 16, right: 15, bottom: 16),
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: child,
      ),
    );
  }
}
