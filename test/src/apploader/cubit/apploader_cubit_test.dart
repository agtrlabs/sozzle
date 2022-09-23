import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sozzle/src/apploader/apploader.dart';

/// mock loader for test
class MockAppLoaderRepo extends Mock implements AppLoaderRepository {}

void main() {
  group('ApploaderCubit', () {
    late ApploaderCubit apploader;

    setUp(() {
      final appLoaderRepo = MockAppLoaderRepo();
      apploader = ApploaderCubit(repository: appLoaderRepo);
    });

    tearDown(() async {
      await apploader.close();
    });

    test('Initial State test', () {
      expect(apploader.state, const ApploaderState(LoaderState.initial));
    });
  });
}
