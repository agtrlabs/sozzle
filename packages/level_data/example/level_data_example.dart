import 'package:level_data/level_data.dart';

void main() {
  const reward = RewardCoin(
    id: 2,
    name: 'Test Coin',
    description: 'Test Coin Description',
    image: 'Test Coin Image',
    points: 500,
  );

  const reward2 = Badge(
    id: 1,
    name: 'Test Badge',
    description: 'Test Badge Description',
    image: 'Test Badge Image',
    points: 50,
  );

  const level = LevelData(
      levelId: 1,
      words: ['SAW', 'WASP'],
      boardHeight: 5,
      boardWidth: 5,
      boardData: ['W', 'S', ''],
      rewards: [
        reward,
        reward2,
      ],
  );

  print(level);

}
