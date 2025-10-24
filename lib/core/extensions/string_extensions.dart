// coverage:ignore-file

import 'package:sozzle/core/enums/rive_enums.dart';

extension StringExtensions on String {
  /// Converts this string to an [AlignmentType] enum value.
  ///
  /// Returns `null` if no matching [AlignmentType] is found.
  AlignmentType? toAlignmentType() {
    for (final alignment in AlignmentType.values) {
      if (alignment.value == this) {
        return alignment;
      }
    }
    return null;
  }

  /// Converts this string to a [LayoutDirection] enum value.
  ///
  /// Returns `null` if no matching [LayoutDirection] is found.
  LayoutDirection? toLayoutDirection() {
    for (final direction in LayoutDirection.values) {
      if (direction.value == this) {
        return direction;
      }
    }
    return null;
  }

  /// Converts this string to a [LayoutScale] enum value.
  ///
  /// Returns `null` if no matching [LayoutScale] is found.
  LayoutScale? toLayoutScale() {
    for (final scale in LayoutScale.values) {
      if (scale.value == this) {
        return scale;
      }
    }
    return null;
  }
}
