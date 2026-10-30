import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// A generic bottom-sheet shell that provides
class AppBottomSheet extends StatelessWidget {
  // Text shown as the sheet title. Pass `null` to omit.
  final String? title;

  // Content rendered below the title. Required.
  final Widget child;

  // Horizontal padding around [child] (default 20).
  final double horizontalPadding;

  // Extra space added at the very bottom on top of the safe-area inset (default 20).
  final double bottomPadding;

  // Whether to show the drag handle at the top (default true).
  final bool showHandle;

  const AppBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.horizontalPadding = 20,
    this.bottomPadding = 20,
    this.showHandle = true,
  });

  // ── Static convenience launcher ─────────────────────────
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    double horizontalPadding = 20,
    double bottomPadding = 20,
    bool showHandle = true,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      builder: (_) => AppBottomSheet(
        title: title,
        horizontalPadding: horizontalPadding,
        bottomPadding: bottomPadding,
        showHandle: showHandle,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final safeBottom = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        0,
        horizontalPadding,
        safeBottom + bottomPadding,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Drag handle ────────────────────────────────
          if (showHandle)
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 20),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD1D5DB),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            )
          else
            const SizedBox(height: 20),

          // ── Title ──────────────────────────────────────
          if (title != null) ...[
            Text(
              title!,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A1A),
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 20),
          ],

          // ── Content ────────────────────────────────────
          child,
        ],
      ),
    );
  }
}
