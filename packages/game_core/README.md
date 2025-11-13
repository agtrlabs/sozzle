# GameCore

The orchestrator package for the Sozzle game, providing centralized game lifecycle management.

## Overview

GameCore is a pure Dart package that manages the main game domain and lifecycle for Sozzle. It provides a clean separation between game logic and UI concerns, making the codebase more maintainable and testable.

## Features

- **Centralized Game State Management**: Single source of truth for game state using BLoC pattern
- **Repository Abstraction**: Clean interfaces for data access (levels, user progress)
- **Domain-Driven Design**: Pure domain models independent of storage implementation
- **Comprehensive Testing**: Full unit test coverage for all state transitions
- **Navigation Coordination**: Declarative navigation based on game state changes

## Architecture

```
packages/game_core/
├── lib/
│   ├── game_core.dart              # Public API exports
│   └── src/
│       ├── bloc/
│       │   ├── game_core_bloc.dart    # Main game orchestrator
│       │   ├── game_core_event.dart   # Game events
│       │   └── game_core_state.dart   # Game states
│       ├── models/
│       │   ├── game_level.dart        # Domain level model
│       │   └── user_progress.dart     # Domain progress model
│       └── repositories/
│           ├── game_level_repository.dart    # Level data interface
│           └── user_progress_repository.dart # Progress data interface
└── test/
    └── src/bloc/
        └── game_core_bloc_test.dart          # Comprehensive bloc tests
```

## Getting Started

### Installation

Add game_core as a dependency in your `pubspec.yaml`:

```yaml
dependencies:
  game_core:
    path: packages/game_core
```

### Basic Usage

1. **Implement Repository Interfaces**

```dart
class MyLevelRepository implements GameLevelRepository {
  @override
  Future<LevelData> load(int levelId) async {
    // Load level from your data source
  }

  @override
  Future<void> save(LevelData level) async {
    // Save level to your data source
  }
}

class MyProgressRepository implements UserProgressRepository {
  @override
  Future<UserProgress> load() async {
    // Load user progress from storage
  }

  @override
  Future<void> save(UserProgress progress) async {
    // Save user progress to storage
  }
}
```

2. **Create and Register GameCoreBloc**

```dart
BlocProvider(
  create: (context) => GameCoreBloc(
    levelRepository: MyLevelRepository(),
    progressRepository: MyProgressRepository(),
  )..add(const GameStarted()),
  child: MyApp(),
)
```

3. **React to Game States**

```dart
BlocBuilder<GameCoreBloc, GameCoreState>(
  builder: (context, state) {
    return switch (state) {
      GameCoreIdle() => HomePage(),
      GameCoreLoadingLevel() => LoadingScreen(),
      GameCorePlaying(:final level) => GamePlayPage(level: level),
      GameCoreLevelWon(:final level) => LevelWonPage(level: level),
      GameCoreError(:final message) => ErrorScreen(message: message),
      GameCoreInitial() => SplashScreen(),
    };
  },
)
```

4. **Dispatch Game Events**

```dart
// Start a level
context.read<GameCoreBloc>().add(PlayLevelRequested(levelId));

// Complete a level
context.read<GameCoreBloc>().add(const LevelCompleted());

// Use a hint
context.read<GameCoreBloc>().add(const HintUsed());

// Return to home
context.read<GameCoreBloc>().add(const ReturnToHomeRequested());
```

## States

### GameCoreInitial
Initial state before the game has started.

### GameCoreIdle
The game is idle and ready for the user to select a level. Contains current user progress.

### GameCoreLoadingLevel
A level is being loaded from the repository.

### GameCorePlaying
A level is currently being played. Contains the level data and user progress.

### GameCoreLevelWon
The current level has been completed. Contains level data, updated progress, and points earned.

### GameCoreError
An error occurred. Contains an error message and current progress.

## Events

### GameStarted
Initialize the game and load user progress.

### PlayLevelRequested
Request to play a specific level by ID.

### LevelCompleted
Mark the current level as completed and update progress.

### HintUsed
Use one hint (if available).

### GameReset
Reset the game and return to idle state.

### NextLevelRequested
Request to play the next level after completing the current one.

### ReturnToHomeRequested
Return to home/idle state from level won.

## Domain Models

### UserProgress
Represents user's progress through the game:
- `currentLevel`: The level the user is currently on
- `points`: Total points earned
- `hintsAvailable`: Number of hints available

### GameLevel
Wraps level data with domain-specific behavior:
- `levelId`: Unique level identifier
- `data`: The underlying LevelData
- `totalWords`: Number of words in the level
- `points`: Points awarded for completion

## State Flow

```
GameCoreInitial
    ↓ GameStarted
GameCoreIdle ←──────────────────┐
    ↓ PlayLevelRequested        │
GameCoreLoadingLevel            │
    ↓                           │
GameCorePlaying                 │
    ↓ LevelCompleted            │
GameCoreLevelWon                │
    ↓ NextLevelRequested        │
    │ or                        │
    ↓ ReturnToHomeRequested ────┘
```

## Testing

The package includes comprehensive unit tests covering:
- All state transitions
- Repository interactions
- Error handling
- Edge cases (e.g., completing level in wrong state, using hints when none available)

Run tests with:
```bash
cd packages/game_core
dart test
```

## Integration with Sozzle App

For Sozzle-specific integration details, including:
- Repository adapters
- Navigation coordination
- UI page integration

See the main app's `lib/src/game_core/` directory and the [Game Core Specification](../../local/game_core_spec.md).

## Contributing

When contributing to GameCore:
1. Ensure all tests pass
2. Add tests for new functionality
3. Keep the package pure Dart (no Flutter dependencies)
4. Follow the existing code style
5. Update this README for significant changes

## License

See the LICENSE file in the repository root.
