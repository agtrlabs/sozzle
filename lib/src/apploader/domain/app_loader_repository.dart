import '../apploader.dart';

abstract class AppLoaderRepository {
  Future<LevelList> getLevels();
  Future<UserProgressData> getUserProgressData();
}
