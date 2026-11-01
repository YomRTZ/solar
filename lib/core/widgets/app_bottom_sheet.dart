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

  // Top margin above the drag handle.
  final double handleTopMargin;

  // Optional action positioned relative to the top-right of the sheet.
  final Widget? topTrailingAction;

  // Optional fixed dimensions and outer horizontal margin.
  final double? sheetWidth;
  final double? sheetHeight;
  final double horizontalMargin;
  final bool includeSafeAreaBottom;

  const AppBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.horizontalPadding = 20,
    this.bottomPadding = 20,
    this.showHandle = true,
    this.handleTopMargin = 12,
    this.topTrailingAction,
    this.sheetWidth,
    this.sheetHeight,
    this.horizontalMargin = 0,
    this.includeSafeAreaBottom = true,
  });

  // ── Static convenience launcher ─────────────────────────
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    double horizontalPadding = 20,
    double bottomPadding = 20,
    bool showHandle = true,
    double handleTopMargin = 12,
    Widget? topTrailingAction,
    double? sheetWidth,
    double? sheetHeight,
    double horizontalMargin = 0,
    bool includeSafeAreaBottom = true,
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
        handleTopMargin: handleTopMargin,
        topTrailingAction: topTrailingAction,
        sheetWidth: sheetWidth,
        sheetHeight: sheetHeight,
        horizontalMargin: horizontalMargin,
        includeSafeAreaBottom: includeSafeAreaBottom,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final safeBottom = MediaQuery.of(context).padding.bottom;
    final availableWidth =
        MediaQuery.sizeOf(context).width - horizontalMargin * 2;
    final resolvedWidth = sheetWidth == null
        ? null
        : (sheetWidth! - horizontalMargin * 2).clamp(0.0, availableWidth);

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: resolvedWidth,
        height: sheetHeight,
        margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.fromLTRB(
          horizontalPadding,
          0,
          horizontalPadding,
          bottomPadding + (includeSafeAreaBottom ? safeBottom : 0),
        ),
        child: Stack(
          fit: sheetHeight == null ? StackFit.loose : StackFit.expand,
          children: [
            Column(
              mainAxisSize: sheetHeight == null
                  ? MainAxisSize.min
                  : MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Drag handle ────────────────────────────────
                if (showHandle)
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: handleTopMargin, bottom: 20),
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
                if (sheetHeight == null) child else Expanded(child: child),
              ],
            ),
            if (topTrailingAction != null)
              Positioned(top: 33.5, right: 20, child: topTrailingAction!),
          ],
        ),
      ),
    );
  }
}
