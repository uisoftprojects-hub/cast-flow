import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

bool isLandscape(BuildContext context) => MediaQuery.orientationOf(context) == Orientation.landscape;

/// A screen's content plus its native ad: the ad sits under the content in
/// portrait and in its own column on the right in landscape, so it never
/// squeezes or covers the content.
class AdSideLayout extends StatelessWidget {
  const AdSideLayout({super.key, required this.content, required this.ad, this.sideWidth = 300});

  final Widget content;
  final Widget ad;
  final double sideWidth;

  @override
  Widget build(BuildContext context) {
    if (!isLandscape(context)) {
      return Column(
        children: [
          Expanded(child: content),
          ad,
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: content),
        SafeArea(
          left: false,
          child: SizedBox(
            width: sideWidth,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(0, AppSpace.sm, AppSpace.page, AppSpace.sm),
                child: ad,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
