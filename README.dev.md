# Sozzle Development Documentation

## Architecture

### GameCore Package

Sozzle uses a centralized game lifecycle management system provided by the `game_core` package. This package orchestrates the main game flow and state transitions.

#### Key Components

1. **GameCoreBloc**: The main orchestrator that manages game state and lifecycle
   - Located in: `packages/game_core/lib/src/bloc/`
   - Registered in: `lib/app.dart`

2. **Repository Adapters**: Bridge between GameCore and existing repositories
   - `LevelRepositoryAdapter`: Adapts `ILevelRepository` to `GameLevelRepository`
   - `UserProgressRepositoryAdapter`: Adapts `IUserStatsRepository` to `UserProgressRepository`
   - Located in: `lib/src/game_core/adapters/`

3. **GameCoreCoordinator**: Shell route that handles navigation based on game state
   - Located in: `lib/src/game_core/coordinator/`
   - Wraps all routes in: `lib/core/routes/routes.dart`

#### State Flow

```
Splash → Home (Idle) → Loading → Playing → Level Won → Home (Idle)
                                    ↓
                                  Next Level
```

- **HomePage**: Dispatches `PlayLevelRequested` event
- **GamePlayPage**: Listens to `GameCorePlaying` state, dispatches `LevelCompleted`
- **LevelCompletePage**: Dispatches `NextLevelRequested` or `ReturnToHomeRequested`
- **GameCoreCoordinator**: Automatically navigates based on state changes

#### Integration Points

- **Game Start**: `GameCoreBloc` is initialized with `GameStarted` event in `app.dart`
- **Level Selection**: HomePage reads `currentLevel` from `GameCoreState.progress`
- **Level Play**: GamePlayPage displays level from `GameCorePlaying.level`
- **Level Completion**: GamePlayBloc triggers `LevelCompleted` event when all words found
- **Progress Persistence**: GameCore automatically saves progress through repository adapters

### Package Structure

```
packages/
  game_core/       # Game lifecycle orchestration (pure Dart)
  level_data/      # Level data models and serialization
  level_generator/ # Procedural level generation
```

### Testing GameCore

Run GameCore tests:
```bash
cd packages/game_core && dart test
```

Run app tests:
```bash
flutter test
```

## Implementation Notes

- The input is not considered if it's less than 3 characters long. Check 
  lib/src/game_play/view/components/game_play_letters.dart:73 -- The _onInputComplete method.

- GameCore uses pure Dart and has no Flutter dependencies, making it highly testable
- Navigation is declarative - the coordinator reacts to state changes automatically
- User progress is automatically persisted when levels are completed
- The existing `UserStatsCubit` still manages boosters independently

## Adding New Features

### Adding a New Game State

1. Add state class to `packages/game_core/lib/src/bloc/game_core_state.dart`
2. Add corresponding event to `game_core_event.dart`
3. Add event handler in `game_core_bloc.dart`
4. Update `GameCoreCoordinator` to handle new state for navigation
5. Add tests in `packages/game_core/test/src/bloc/game_core_bloc_test.dart`

### Modifying Level Flow

1. Update GameCore events/states as needed
2. Modify coordinator navigation logic if needed
3. Update UI pages to dispatch new events
4. Ensure tests cover new flow

## Debugging

To debug game state transitions:
- GameCore logs all transitions with the name `GameCoreBloc`
- Check logs for: "GameCore: Starting game", "GameCore: Loading level X", etc.
- Use Flutter DevTools to inspect `GameCoreBloc` state in real-time

## Documentation

- GameCore API: `packages/game_core/README.md`
