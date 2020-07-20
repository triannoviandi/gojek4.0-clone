library flutter_bubble_tab_indicator;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math;

/// Used with [TabBar.indicator] to draw a bubble on the
/// selected tab.
///
/// The [indicatorHeight] defines the bubble height.
/// The [indicatorColor] defines the bubble color.
/// The [indicatorRadius] defines the bubble corner radius.
/// The [tabBarIndicatorSize] specifies the type of TabBarIndicatorSize i.e label or tab.
/// /// The selected tab bubble is inset from the tab's boundary by [insets] when [tabBarIndicatorSize] is tab.
/// The selected tab bubble is applied padding by [padding] when [tabBarIndicatorSize] is label.

class BubbleTabIndicator extends Decoration {
  final double indicatorHeight;
  final Color indicatorColor;
  final double indicatorRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry insets;
  final TabBarIndicatorSize tabBarIndicatorSize;

  const BubbleTabIndicator({
    this.indicatorHeight: 20.0,
    this.indicatorColor: Colors.greenAccent,
    this.indicatorRadius: 100.0,
    this.tabBarIndicatorSize = TabBarIndicatorSize.label,
    this.padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0),
    this.insets: const EdgeInsets.symmetric(horizontal: 0.0),
  })  : assert(indicatorHeight != null),
        assert(indicatorColor != null),
        assert(indicatorRadius != null),
        assert(padding != null),
        assert(insets != null);

  @override
  Decoration lerpFrom(Decoration a, double t) {
    if (a is BubbleTabIndicator) {
      return new BubbleTabIndicator(
        padding: EdgeInsetsGeometry.lerp(a.padding, padding, t),
        insets: EdgeInsetsGeometry.lerp(a.insets, insets, t),
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  Decoration lerpTo(Decoration b, double t) {
    if (b is BubbleTabIndicator) {
      return new BubbleTabIndicator(
        padding: EdgeInsetsGeometry.lerp(padding, b.padding, t),
        insets: EdgeInsetsGeometry.lerp(insets, b.insets, t),
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  _BubblePainter createBoxPainter([VoidCallback onChanged]) {
    return new _BubblePainter(this, onChanged);
  }
}

class _BubblePainter extends BoxPainter {
  _BubblePainter(this.decoration, VoidCallback onChanged)
      : assert(decoration != null),
        super(onChanged);

  final BubbleTabIndicator decoration;

  double get indicatorHeight => decoration.indicatorHeight;
  Color get indicatorColor => decoration.indicatorColor;
  double get indicatorRadius => decoration.indicatorRadius;
  EdgeInsetsGeometry get padding => decoration.padding;
  EdgeInsetsGeometry get insets => decoration.insets;
  TabBarIndicatorSize get tabBarIndicatorSize => decoration.tabBarIndicatorSize;

  double initialOffset;
  double stopOffset;

  Rect _indicatorRectFor(Rect rect, TextDirection textDirection) {
    assert(rect != null);
    assert(textDirection != null);

    Rect indicator = padding.resolve(textDirection).inflateRect(rect);

    if (tabBarIndicatorSize == TabBarIndicatorSize.tab) {
      indicator = insets.resolve(textDirection).deflateRect(rect);
    }

    return new Rect.fromLTWH(
      indicator.left,
      indicator.top,
      indicator.width,
      indicator.height,
    );
  }

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    if (initialOffset == null)
      initialOffset = (offset.dx - configuration.size.width) / 3;

    assert(configuration != null);
    assert(configuration.size != null);

    double dxOffset;
    double currenStopOffset =
        getStopOffset(initialOffset, configuration.size.width, offset.dx);
    stopOffset = currenStopOffset ?? stopOffset;
    if (offset.dx >= stopOffset) {
      dxOffset =
          offsetControl(initialOffset, configuration.size.width, offset.dx);
    } else {
      dxOffset = offsetControlFromRigth(
          initialOffset, configuration.size.width, offset.dx);
    }

    final Rect rect = Offset(
            dxOffset, (configuration.size.height / 2) - indicatorHeight / 2) &
        Size(
            configuration.size.width +
                widthControl(
                    initialOffset, configuration.size.width, offset.dx),
            indicatorHeight);
    final TextDirection textDirection = configuration.textDirection;
    final Rect indicator = _indicatorRectFor(rect, textDirection);
    final Paint paint = Paint();
    paint.color = indicatorColor;

    paint.style = PaintingStyle.fill;
    canvas.drawRRect(
        RRect.fromRectAndRadius(indicator, Radius.circular(indicatorRadius)),
        paint);
  }

  double widthControl(double initialOffset, double baseWidth, double offset) {
    double tabWidth = initialOffset * 2 + baseWidth;

    if (offset < tabWidth + initialOffset) {
      double halfEnd = tabWidth / 2 + initialOffset;
      if (offset < halfEnd) {
        return (offset - initialOffset) * 1.5;
      } else {
        return (halfEnd - initialOffset + halfEnd - offset) * 1.5;
      }
    } else if (offset < tabWidth * 2 + initialOffset) {
      double halfEnd = tabWidth / 2 + initialOffset + tabWidth;
      if (offset < halfEnd) {
        double x = (offset - initialOffset - tabWidth) * 1.5;
        return x;
      } else {
        return ((tabWidth / 2) + (halfEnd - offset)) * 1.5;
      }
    } else
      return 0;
  }

  double offsetControl(double initialOffset, double baseWidth, double offset) {
    double tabWidth = initialOffset * 2 + baseWidth;
    if (offset < tabWidth + initialOffset) {
      double halfEnd = tabWidth / 2 + initialOffset;
      if (offset < halfEnd)
        return initialOffset;
      else {
        double x = offset - halfEnd;
        return x * 2 + initialOffset;
      }
    } else if (offset < (tabWidth * 2 + initialOffset)) {
      double halfEnd = tabWidth / 2 + initialOffset + tabWidth;
      if (offset < halfEnd)
        return tabWidth + initialOffset;
      else {
        double x = offset - halfEnd;
        return x * 2 + initialOffset + tabWidth;
      }
    } else {
      return offset;
    }
  }

  double offsetControlFromRigth(
      double initialOffset, double baseWidth, double offset) {
    double tabWidth = initialOffset * 2 + baseWidth;
    if (offset < tabWidth + initialOffset) {
      double halfEnd = tabWidth / 2 + initialOffset;
      if (offset < halfEnd) {
        double x = (offset - halfEnd) * .5;
        return (tabWidth +
                ((halfEnd - tabWidth - initialOffset) * 1.5) +
                initialOffset) +
            x;
      } else {
        double x = offset - tabWidth - initialOffset;
        return tabWidth + (x * 1.5) + initialOffset;
      }
    } else if (offset < (tabWidth * 2 + initialOffset)) {
      double halfEnd = tabWidth / 2 + initialOffset + tabWidth;

      if (offset < halfEnd) {
        double x = (offset - halfEnd) * .5;

        return ((tabWidth * 2) +
                ((halfEnd - (tabWidth * 2) - initialOffset) * 1.5) +
                initialOffset) +
            x;
      } else {
        double x = offset - (tabWidth * 2) - initialOffset;
        return (tabWidth * 2) + (x * 1.5) + initialOffset;
      }
    } else {
      return offset;
    }
  }

  double roundDouble(double value, int places) {
    double mod = math.pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  double getStopOffset(double initialOffset, double baseWidth, double offset) {
    double secondStop = initialOffset * 3 + baseWidth;
    double thirdStop = initialOffset * 5 + baseWidth * 2;

    if (roundDouble(offset, 8) == roundDouble(initialOffset, 8)) {
      return initialOffset;
    } else if (roundDouble(offset, 8) == roundDouble(secondStop, 8)) {
      return secondStop;
    } else if (roundDouble(offset, 8) == roundDouble(thirdStop, 8)) {
      return thirdStop;
    }
    return null;
  }
}
