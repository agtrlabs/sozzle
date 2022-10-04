import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sozzle/src/common/border_elevated_button.dart';
import 'package:sozzle/src/theme/theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static const String path = 'home';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: state.backgroundColor,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Sozzle Home Page',
                  style: TextStyle(
                    color: state.primaryTextColor,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                BorderElevatedButton(
                  route: '/home/settings',
                  text: 'Settings',
                  backgroundColor: Colors.blue,
                  borderColor: Colors.white,
                  textColor: state.primaryTextColor,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
