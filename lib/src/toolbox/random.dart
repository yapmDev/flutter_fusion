import 'dart:math';
import 'dart:ui';

final _random = Random();

/// Returns a random integer (even negative values) in a given range, limits are included.
///
/// [min] for the lower limit and [max] for the upper limit.
///
/// Throws an [AssertionError] if [max] is less than [min].
int randomNumber(int min, int max) {
  assert(max >= min, "The arguments are being provided incorrectly, max must be greater than min");
  return _random.nextInt(max - min + 1) + min;
}

/// Returns a completely random color from [RGBO], keeping [opacity] equal to 1.
Color randomColor() => Color.fromRGBO(
  randomNumber(0, 255),
  randomNumber(0, 255),
  randomNumber(0, 255),
  1,
);