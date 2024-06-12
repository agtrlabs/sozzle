/// Current Users progress data
class UserProgressData {
  UserProgressData({required this.currentLevel});

  factory UserProgressData.fromMap(Map<String, dynamic> json) =>
      UserProgressData(currentLevel: json['currentLevel'] as int);

  /// max level user reached
  int currentLevel;

  Map<String, dynamic> toMap() => {'currentLevel': currentLevel};
}
