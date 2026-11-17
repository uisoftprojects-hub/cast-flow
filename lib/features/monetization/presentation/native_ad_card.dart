import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';

/// Reusable Native Ad Visual Design matching Section 7 specifications:
/// - Rectangle card with subtle border and rounded corners.
/// - Left section: exactly 35% width with advertiser icon proportionally filling, clipped to card corners.
/// - Right section: exactly 65% width with Ad disclosure label, 2-line title, 1-line description, and CTA button.
/// - Full available width, zero horizontal screen padding.
/// - Supports both Light and Dark themes.
class NativeAdCard extends StatelessWidget {
  const NativeAdCard({
    super.key,
    required this.title,
    required this.description,
    required this.ctaText,
    required this.onCtaPressed,
    this.iconWidget,
    this.height = 120.0,
  });

  final String title;
  final String description;
  final String ctaText;
  final VoidCallback onCtaPressed;
  final Widget? iconWidget;
  final double height;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final p = context.palette;

    final cardBg = isDark ? const Color(0xFF1A1D24) : Colors.white;
    final cardBorder = isDark
        ? const Color(0xFF2E333D)
        : const Color(0xFFE5E7EB);
    final titleColor = isDark ? Colors.white : const Color(0xFF111827);
    final descColor = isDark
        ? const Color(0xFF9CA3AF)
        : const Color(0xFF6B7280);

    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.zero,
        border: Border.all(color: cardBorder, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left section: 35% width with 4 inside margin
          Expanded(
            key: const ValueKey('native_ad_left_35'),
            flex: 35,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child:
                  iconWidget ??
                  Container(
                    color: isDark
                        ? const Color(0xFF252A34)
                        : const Color(0xFFF3F4F6),
                    child: Center(
                      child: Icon(
                        Icons.campaign_rounded,
                        size: 40,
                        color: isDark
                            ? const Color(0xFF4B5563)
                            : const Color(0xFF9CA3AF),
                      ),
                    ),
                  ),
            ),
          ),

          // Right section: 65% width
          Expanded(
            key: const ValueKey('native_ad_right_65'),
            flex: 65,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 1. Small Ad disclosure label
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF374151)
                          : const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'AD',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF6B7280),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),

                  // 2. Headline (maximum 2 lines)
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: titleColor,
                      height: 1.2,
                    ),
                  ),

                  // 3. Body text (maximum 1 line)
                  Text(
                    description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color: descColor,
                      height: 1.1,
                    ),
                  ),

                  // 4. CTA Button (fills available horizontal space)
                  SizedBox(
                    width: double.infinity,
                    height: 28,
                    child: ElevatedButton(
                      onPressed: onCtaPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: p.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                      ),
                      child: Text(
                        ctaText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
