// coverage:ignore-file

/// Represents the primary direction of layout.
enum LayoutDirection {
  column('Column'),
  columnReverse('Column Reverse'),
  row('Row'),
  rowReverse('Row Reverse');

  const LayoutDirection(this.value);

  final String value;
}

/// Represents various types of alignment for layout.
enum AlignmentType {
  topLeft('Top Left'),
  topCenter('Top Center'),
  topRight('Top Right'),
  centerLeft('Center Left'),
  center('Center'),
  centerRight('Center Right'),
  bottomLeft('Bottom Left'),
  bottomCenter('Bottom Center'),
  bottomRight('Bottom Right'),
  spaceBetweenStart('Space Between Start'),
  spaceBetweenCenter('Space Between Center'),
  spaceBetweenEnd('Space Between End');

  const AlignmentType(this.value);

  final String value;
}

/// Represents different scaling options for layout.
enum LayoutScale {
  fixed('Fixed'),
  fill('Fill'),
  hug('Hug');

  const LayoutScale(this.value);
  final String value;
}
