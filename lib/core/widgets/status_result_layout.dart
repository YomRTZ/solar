import 'dart:math' as math;

import 'package:flutter/material.dart';

class StatusResultLayout extends StatelessWidget {
  final Widget icon;
  final Widget title;
  final Widget description;
  final Widget? button;

  const StatusResultLayout({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.button,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(19, 133, 14, 210),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final sideInset = math.min(
                  108.0,
                  math.max(0.0, (constraints.maxWidth - 111) / 2),
                );
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: sideInset),
                  child: icon,
                );
              },
            ),
            const SizedBox(height: 27),
            title,
            const SizedBox(height: 8),
            description,
            if (button != null) ...[const SizedBox(height: 27), button!],
          ],
        ),
      ),
    );
  }
}
