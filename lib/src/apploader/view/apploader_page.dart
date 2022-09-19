import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sozzle/src/apploader/apploader.dart';

class ApploaderPage extends StatelessWidget {
  const ApploaderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ApploaderCubit(),
      child: const ApploaderView(),
    );
  }
}

class ApploaderView extends StatelessWidget {
  const ApploaderView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApploaderCubit, ApploaderState>(
      builder: (context, state) {
        // TODO: return correct widget based on the state.
        return const SizedBox();
      },
    );
  }
}
