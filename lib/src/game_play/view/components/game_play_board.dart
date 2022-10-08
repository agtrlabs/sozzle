import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sozzle/src/theme/cubit/theme_cubit.dart';

class GamePlayBoard extends StatelessWidget {
  const GamePlayBoard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = BlocProvider.of<ThemeCubit>(context).state;
    return FittedBox(
      fit: BoxFit.fill,
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: theme.backgroundColor,
        child: Text(
          'Play Board!',
          style: TextStyle(color: theme.primaryTextColor),
        ),
      ),
    );
  }
}
