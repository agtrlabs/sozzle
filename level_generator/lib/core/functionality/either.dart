
import 'package:equatable/equatable.dart';

abstract class Either<L, R> {
  const Either();
  C unfold<C>(
      C Function(L left) onLeft,
      C Function(R right) onRight,
      );
}

class Left<L, R> extends Equatable implements Either<L, R> {
  final L _l;
  const Left(this._l);

  @override
  List<L> get props => [_l];

  @override
  C unfold<C>(
      C Function(L left) onLeft,
      C Function(R right) onRight,
      ) => onLeft(_l);
}

class Right<L, R> extends Equatable implements Either<L, R> {
  final R _r;
  const Right(this._r);

  @override
  List<R> get props => [_r];

  @override
  C unfold<C>(
      C Function(L left) onLeft,
      C Function(R right) onRight,
      ) => onRight(_r);
}

