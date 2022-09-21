import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sozzle/src/apploader/cubit/apploader_cubit.dart';

void main() {
  group('ApploaderCubit', () {
    late ApploaderCubit apploader;

    setUp(() {
      apploader = ApploaderCubit();
    });

    tearDown(() async {
      await apploader.close();
    });

    test('Initial State test', () {
      expect(apploader.state, const ApploaderState(LoaderState.initial));
    });

    
  });
}
