// coverage:ignore-file
// ignore_for_file: constant_identifier_names

enum EnvironmentType { DEVELOPMENT, STAGING, PRODUCTION }

class Environment {
  Environment._internal();

  static final Environment instance = Environment._internal();

  EnvironmentType _type = EnvironmentType.DEVELOPMENT;

  EnvironmentType get type => _type;

  void setEnvironment(EnvironmentType type) {
    if (_type != type) _type = type;
  }
}
