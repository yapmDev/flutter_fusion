import 'package:flutter/material.dart';

/// Displays a toast message in the given [context].
///
/// @Params:
///
/// [message] : the message will be shown (required).
///
/// [context] : determines where the toast will be shown (required).
///
/// [decoration] : can be used to customize the appearance of the toast container.
///
/// [duration] : sets how long the toast will be visible (default is 2 seconds).
///
/// [leadingIcon] : can be an optional icon displayed before the message.
///
/// [textStyle] : can be used to customize the appearance of the message text.
///
/// [position] : the position on the screen where this toast will show up (default is at the
/// bottom).
///
/// See also the [Builder] widget, could be necessary to make sure the most inner context is
/// provided, specially when you use a specific theme with [ToastTheme].
void showToast({
  required BuildContext context,
  required String message,
  BoxDecoration? decoration,
  Duration duration = const Duration(seconds: 2),
  Icon? leadingIcon,
  TextStyle? textStyle,
  ToastPosition position = ToastPosition.bottom //del
}) {
  ToastThemeData toastTheme = ToastTheme.of(context);
  OverlayEntry overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: position.fromTop,
      left: position.fromLeft,
      right: position.fromRight,
      bottom: position.fromBottom,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: decoration ?? toastTheme.decoration,
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (leadingIcon != null) leadingIcon,
                if (leadingIcon != null) const SizedBox(width: 10.0),
                Text(message, style: textStyle ?? toastTheme.textStyle),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  Overlay.of(context).insert(overlayEntry);

  Future.delayed(duration, () {
    overlayEntry.remove();
  });
}

/// Holds the theming data for toast messages.
@immutable
class ToastThemeData extends ThemeExtension<ToastThemeData> {
  /// The decoration for the toast container.
  final BoxDecoration? decoration;

  /// The text style for the toast message.
  final TextStyle? textStyle;

  /// Creates a [ToastThemeData] with the given [decoration] and [textStyle].
  const ToastThemeData({
    this.decoration,
    this.textStyle,
  });

  @override
  ToastThemeData copyWith({BoxDecoration? decoration, TextStyle? textStyle}) {
    return ToastThemeData(
      decoration: decoration ?? this.decoration,
      textStyle: textStyle ?? this.textStyle,
    );
  }

  @override
  ToastThemeData lerp(covariant ThemeExtension<ToastThemeData>? other, double t) {
    if (other is! ToastThemeData) return this;
    return ToastThemeData(
      decoration: BoxDecoration.lerp(decoration, other.decoration, t),
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ToastThemeData &&
              runtimeType == other.runtimeType &&
              decoration == other.decoration &&
              textStyle == other.textStyle;

  @override
  int get hashCode => decoration.hashCode ^ textStyle.hashCode;
}

/// An inherited widget that provides [ToastThemeData] to its descendants.
class ToastTheme extends InheritedWidget {
  /// The [ToastThemeData] that is provided to the descendants.
  final ToastThemeData data;

  /// Creates a [ToastTheme] with the given [data] and [child].
  const ToastTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// Retrieves the nearest [ToastThemeData] up the widget tree.
  ///
  /// If no [ToastTheme] is found, the default [ToastThemeData] from the current
  /// [ThemeData] is returned.
  static ToastThemeData of(BuildContext context) {
    final ToastTheme? toastTheme = context.dependOnInheritedWidgetOfExactType<ToastTheme>();
    return toastTheme?.data ?? Theme.of(context).toastTheme;
  }

  @override
  bool updateShouldNotify(ToastTheme oldWidget) => data != oldWidget.data;
}

/// Extension on [ThemeData] to include [ToastThemeData].
extension ToastThemeExtension on ThemeData {
  /// Retrieves the [ToastThemeData] from the theme extensions.
  ///
  /// If no [ToastThemeData] is found, a default one is created.
  ToastThemeData get toastTheme {
    return extension<ToastThemeData>() ??
        ToastThemeData(
          decoration: BoxDecoration(
            border: Border.all(color: colorScheme.onBackground),
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            color: colorScheme.background,
          ),
          textStyle: const TextStyle(),
        );
  }
}

///The possibles positions for the toasts which will be display using [showToast].
enum ToastPosition{
  top(fromTop: 50.0, fromLeft: 0.0, fromRight: 0.0),
  topLeft(fromTop: 50.0, fromLeft: 50.0),
  topRight(fromTop: 50.0, fromRight: 50.0),
  left(fromTop: 0.0, fromLeft: 50.0, fromBottom: 0.0),
  center(fromTop: 0.0, fromLeft: 0.0, fromRight: 0.0, fromBottom: 0.0),
  right(fromTop: 0.0, fromRight: 50.0, fromBottom: 0.0),
  bottom(fromBottom: 50.0, fromLeft: 0.0, fromRight: 0.0),
  bottomLeft(fromBottom: 50.0, fromLeft: 50.0),
  bottomRight(fromBottom: 50.0, fromRight: 50.0);

  const ToastPosition({
    this.fromTop,
    this.fromLeft,
    this.fromRight,
    this.fromBottom,
  });

  final double? fromTop;
  final double? fromLeft;
  final double? fromRight;
  final double? fromBottom;
}