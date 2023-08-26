import 'dart:ui';

import 'package:flutter/material.dart';


const double _kCircularIndicatorDiameter = 56;
const double _kIndicatorHeight = 32;


class _RailDestination extends StatelessWidget {
  _RailDestination({
    required this.minWidth,
    required this.minExtendedWidth,
    required this.icon,
    required this.label,
    required this.destinationAnimation,
    required this.extendedTransitionAnimation,
    required this.labelType,
    required this.selected,
    required this.iconTheme,
    required this.labelTextStyle,
    required this.onTap,
    required this.indexLabel,
    this.padding,
    required this.useIndicator,
    this.indicatorColor,
    this.indicatorShape,
  }) : _positionAnimation = CurvedAnimation(
          parent: ReverseAnimation(destinationAnimation),
          curve: Curves.easeInOut,
          reverseCurve: Curves.easeInOut.flipped,
       );

  final double minWidth;
  final double minExtendedWidth;
  final Widget icon;
  final Widget label;
  final Animation<double> destinationAnimation;
  final NavigationRailLabelType labelType;
  final bool selected;
  final Animation<double> extendedTransitionAnimation;
  final IconThemeData iconTheme;
  final TextStyle labelTextStyle;
  final VoidCallback onTap;
  final String indexLabel;
  final EdgeInsetsGeometry? padding;
  final bool useIndicator;
  final Color? indicatorColor;
  final ShapeBorder? indicatorShape;

  final Animation<double> _positionAnimation;

   double _horizontalDestinationPadding = 8.0;
static const double _verticalDestinationPaddingNoLabel = 24.0;
static const double _verticalDestinationPaddingWithLabel = 16.0;
  static const Widget _verticalSpacer = SizedBox(height: 8.0);
  static const double _verticalIconLabelSpacingM3 = 4.0;
static const double _verticalDestinationSpacingM3 = 12.0;
static const double _horizontalDestinationSpacingM3 = 12.0;

  @override
  Widget build(BuildContext context) {
    assert(
      useIndicator || indicatorColor == null,
      '[NavigationRail.indicatorColor] does not have an effect when [NavigationRail.useIndicator] is false',
    );

    final bool material3 = Theme.of(context).useMaterial3;
    final EdgeInsets destinationPadding = (padding ?? EdgeInsets.zero).resolve(Directionality.of(context));
    Offset indicatorOffset;

    final Widget themedIcon = IconTheme(
      data: iconTheme,
      child: icon,
    );
    final Widget styledLabel = DefaultTextStyle(
      style: labelTextStyle,
      child: label,
    );

    Widget content;

    switch (labelType) {
      case NavigationRailLabelType.none:
        // Split the destination spacing across the top and bottom to keep the icon centered.
        final Widget? spacing = material3 ? const SizedBox(height: _verticalDestinationSpacingM3 / 2) : null;
        indicatorOffset = Offset(
          minWidth / 2 + destinationPadding.left,
          _verticalDestinationSpacingM3 / 2 + destinationPadding.top,
        );
        final Widget iconPart = Column(
          children: <Widget>[
            if (spacing != null) spacing,
            SizedBox(
              width: minWidth,
              height: material3 ? null : minWidth,
              child: Center(
                child: _AddIndicator(
                  addIndicator: useIndicator,
                  indicatorColor: indicatorColor,
                  indicatorShape: indicatorShape,
                  isCircular: !material3,
                  indicatorAnimation: destinationAnimation,
                  child: themedIcon,
                ),
              ),
            ),
            if (spacing != null) spacing,
          ],
        );
        if (extendedTransitionAnimation.value == 0) {
          content = Padding(
            padding: padding ?? EdgeInsets.zero,
            child: Stack(
              children: <Widget>[
                iconPart,
                // For semantics when label is not showing,
                SizedBox.shrink(
                  child: Visibility.maintain(
                    visible: false,
                    child: label,
                  ),
                ),
              ],
            ),
          );
        } else {
          final Animation<double> labelFadeAnimation = extendedTransitionAnimation.drive(CurveTween(curve: const Interval(0.0, 0.25)));
          content = Padding(
            padding: padding ?? EdgeInsets.zero,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: lerpDouble(minWidth, minExtendedWidth, extendedTransitionAnimation.value)!,
              ),
              child: ClipRect(
                child: Row(
                  children: <Widget>[
                    iconPart,
                    Align(
                      heightFactor: 1.0,
                      widthFactor: extendedTransitionAnimation.value,
                      alignment: AlignmentDirectional.centerStart,
                      child: FadeTransition(
                        alwaysIncludeSemantics: true,
                        opacity: labelFadeAnimation,
                        child: styledLabel,
                      ),
                    ),
                    SizedBox(width: _horizontalDestinationPadding * extendedTransitionAnimation.value),
                  ],
                ),
              ),
            ),
          );
        }
      case NavigationRailLabelType.selected:
        final double appearingAnimationValue = 1 - _positionAnimation.value;
        final double verticalPadding = lerpDouble(_verticalDestinationPaddingNoLabel, _verticalDestinationPaddingWithLabel, appearingAnimationValue)!;
        final Interval interval = selected ? const Interval(0.25, 0.75) : const Interval(0.75, 1.0);
        final Animation<double> labelFadeAnimation = destinationAnimation.drive(CurveTween(curve: interval));
        final double minHeight = material3 ? 0 : minWidth;
        final Widget topSpacing = SizedBox(height: material3 ? 0 : verticalPadding);
        final Widget labelSpacing = SizedBox(height: material3 ? lerpDouble(0, _verticalIconLabelSpacingM3, appearingAnimationValue)! : 0);
        final Widget bottomSpacing = SizedBox(height: material3 ? _verticalDestinationSpacingM3 : verticalPadding);
        final double indicatorHorizontalPadding = (destinationPadding.left / 2) - (destinationPadding.right / 2);
        final double indicatorVerticalPadding = destinationPadding.top;
        indicatorOffset = Offset(minWidth / 2 + indicatorHorizontalPadding, indicatorVerticalPadding);
        if (minWidth < _NavigationRailDefaultsM2(context).minWidth!) {
          indicatorOffset = Offset(minWidth / 2 + _horizontalDestinationSpacingM3, indicatorVerticalPadding);
        }
        content = Container(
          constraints: BoxConstraints(
            minWidth: minWidth,
            minHeight: minHeight,
          ),
          padding: padding ??  EdgeInsets.symmetric(horizontal: _horizontalDestinationPadding),
          child: ClipRect(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                topSpacing,
                _AddIndicator(
                  addIndicator: useIndicator,
                  indicatorColor: indicatorColor,
                  indicatorShape: indicatorShape,
                  isCircular: false,
                  indicatorAnimation: destinationAnimation,
                  child: themedIcon,
                ),
                labelSpacing,
                Align(
                  alignment: Alignment.topCenter,
                  heightFactor: appearingAnimationValue,
                  widthFactor: 1.0,
                  child: FadeTransition(
                    alwaysIncludeSemantics: true,
                    opacity: labelFadeAnimation,
                    child: styledLabel,
                  ),
                ),
                bottomSpacing,
              ],
            ),
          ),
        );
      case NavigationRailLabelType.all:
        final double minHeight = material3 ? 0 : minWidth;
        final Widget topSpacing = SizedBox(height: material3 ? 0 : _verticalDestinationPaddingWithLabel);
        final Widget labelSpacing = SizedBox(height: material3 ? _verticalIconLabelSpacingM3 : 0);
        final Widget bottomSpacing = SizedBox(height: material3 ? _verticalDestinationSpacingM3 : _verticalDestinationPaddingWithLabel);
        final double indicatorHorizontalPadding = (destinationPadding.left / 2) - (destinationPadding.right / 2);
        final double indicatorVerticalPadding = destinationPadding.top;
        indicatorOffset = Offset(minWidth / 2 + indicatorHorizontalPadding, indicatorVerticalPadding);
        if (minWidth < _NavigationRailDefaultsM2(context).minWidth!) {
          indicatorOffset = Offset(minWidth / 2 + _horizontalDestinationSpacingM3, indicatorVerticalPadding);
        }
        content = Container(
          constraints: BoxConstraints(
            minWidth: minWidth,
            minHeight: minHeight,
          ),
          padding: padding ??  EdgeInsets.symmetric(horizontal: _horizontalDestinationPadding),
          child: Column(
            children: <Widget>[
              topSpacing,
              _AddIndicator(
                addIndicator: useIndicator,
                indicatorColor: indicatorColor,
                indicatorShape: indicatorShape,
                isCircular: false,
                indicatorAnimation: destinationAnimation,
                child: themedIcon,
              ),
              labelSpacing,
              styledLabel,
              bottomSpacing,
            ],
          ),
        );
    }

    final ColorScheme colors = Theme.of(context).colorScheme;
    return Semantics(
      container: true,
      selected: selected,
      child: Stack(
        children: <Widget>[
          Material(
            type: MaterialType.transparency,
            child: _IndicatorInkWell(
              onTap: onTap,
              borderRadius: BorderRadius.all(Radius.circular(minWidth / 2.0)),
              customBorder: indicatorShape,
              splashColor: colors.primary.withOpacity(0.12),
              hoverColor: colors.primary.withOpacity(0.04),
              useMaterial3: material3,
              indicatorOffset: indicatorOffset,
              child: content,
            ),
          ),
          Semantics(
            label: indexLabel,
          ),
        ],
      ),
    );
  }
}

class _IndicatorInkWell extends InkResponse {
  const _IndicatorInkWell({
    super.child,
    super.onTap,
    ShapeBorder? customBorder,
    BorderRadius? borderRadius,
    super.splashColor,
    super.hoverColor,
    required this.useMaterial3,
    required this.indicatorOffset,
  }) : super(
    containedInkWell: true,
    highlightShape: BoxShape.rectangle,
    borderRadius: useMaterial3 ? null : borderRadius,
    customBorder: useMaterial3 ? customBorder : null,
  );

  final bool useMaterial3;
  final Offset indicatorOffset;

  @override
  RectCallback? getRectCallback(RenderBox referenceBox) {
    if (useMaterial3) {
      return () {
        return Rect.fromLTWH(
          indicatorOffset.dx - (_kCircularIndicatorDiameter / 2),
          indicatorOffset.dy,
          _kCircularIndicatorDiameter,
          _kIndicatorHeight,
        );
      };
    }
    return null;
  }
}

class _AddIndicator extends StatelessWidget {
  const _AddIndicator({
    required this.addIndicator,
    required this.isCircular,
    required this.indicatorColor,
    required this.indicatorShape,
    required this.indicatorAnimation,
    required this.child,
  });

  final bool addIndicator;
  final bool isCircular;
  final Color? indicatorColor;
  final ShapeBorder? indicatorShape;
  final Animation<double> indicatorAnimation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!addIndicator) {
      return child;
    }
    late final Widget indicator;
    if (isCircular) {
      indicator = NavigationIndicator(
        animation: indicatorAnimation,
        height: _kCircularIndicatorDiameter,
        width: _kCircularIndicatorDiameter,
        borderRadius: BorderRadius.circular(_kCircularIndicatorDiameter / 2),
        color: indicatorColor,
      );
    } else {
      indicator = NavigationIndicator(
        animation: indicatorAnimation,
        width: _kCircularIndicatorDiameter,
        shape: indicatorShape,
        color: indicatorColor,
      );
    }

    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        indicator,
        child,
      ],
    );
  }
}

enum NavigationRailLabelType {
  /// Only the [NavigationRailDestination]s are shown.
  none,

  /// Only the selected [NavigationRailDestination] will show its label.
  ///
  /// The label will animate in and out as new [NavigationRailDestination]s are
  /// selected.
  selected,

  /// All [NavigationRailDestination]s will show their label.
  all,
}


// Hand coded defaults based on Material Design 2.
class _NavigationRailDefaultsM2 extends NavigationRailThemeData {
  _NavigationRailDefaultsM2(BuildContext context)
    : _theme = Theme.of(context),
      _colors = Theme.of(context).colorScheme,
      super(
        elevation: 0,
        groupAlignment: -1,
        labelType:  NavigationRailLabelType.none ,
        useIndicator: false,
        minWidth: 72.0,
        minExtendedWidth: 256,
      );

  final ThemeData _theme;
  final ColorScheme _colors;

  @override Color? get backgroundColor => _colors.surface;

  @override TextStyle? get unselectedLabelTextStyle {
    return _theme.textTheme.bodyLarge!.copyWith(color: _colors.onSurface.withOpacity(0.64));
  }

  @override TextStyle? get selectedLabelTextStyle {
    return _theme.textTheme.bodyLarge!.copyWith(color: _colors.primary);
  }

  @override IconThemeData? get unselectedIconTheme {
    return IconThemeData(
      size: 24.0,
      color: _colors.onSurface,
      opacity: 0.64,
    );
  }

  @override IconThemeData? get selectedIconTheme {
    return IconThemeData(
      size: 24.0,
      color: _colors.primary,
      opacity: 1.0,
    );
  }
}
