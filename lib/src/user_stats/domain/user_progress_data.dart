/// Current Users progress data
class UserProgressData {
  UserProgressData({required this.currentLevel, this.hintCount = 0});

  factory UserProgressData.fromMap(Map<String, dynamic> json) =>
      UserProgressData(
        currentLevel: json['currentLevel'] as int,
        hintCount: json['hintCount'] as int,
      );

  /// max level user reached
  int currentLevel;
  int hintCount;

  Map<String, dynamic> toMap() => {
        'currentLevel': currentLevel,
        'hintCount': hintCount,
      };
}
