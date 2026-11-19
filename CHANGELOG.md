# Changelog

## [Unreleased] - 2026-11-19

### Added
- Complete project foundation with 143 files
- 11 autoload systems (EventBus, InputRouter, GameState, SceneManager, AudioManager, SaveManager, Analytics, Constants, DebugManager, GameData, AppState)
- 30+ reusable components (Health, Stagger, Hitbox, Hurtbox, StateMachine, etc)
- 13 state machine states for player/enemy behavior
- Player system (Raka & Nisa with abilities)
- Enemy system (Archer, Swordsman, Boss Golemkala)
- UI system (MainMenu, HUD, Dialog, Pause, Options, Results)
- 9 data resource files with PRD values
- Comprehensive documentation (README, DEVLOG, TODO, PROGRESS, SETUP)

### Fixed
- Type inference issues (replaced `:=` with explicit types)
- Constants autoload naming conflict (removed class_name)
- AppState enum conflict renamed GameState to AppGameState
- ArrowProjectile changed from Area2D to CharacterBody2D
- MainMenu.tscn corrected to proper scene format
- WaveManager signal annotation syntax
- Chinese characters in down_state.gd replaced with English
- Health/Stagger component references (use Node instead of typed)
- DEBUG_MODE changed from const to var for runtime evaluation
- All parse errors resolved - project compiles cleanly

## [0.1.0] - 2026-11-19

### Initial Release
- Project structure created according to PRD
- Phase 1 Foundation complete
- Ready for scene implementation in Godot Editor
