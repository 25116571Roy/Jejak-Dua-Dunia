# Setup Guide - Jejak Asa: Dua Arah Pulang

## Prerequisites
- Godot Engine 4.7 atau lebih baru
- Git
- Basic knowledge of Godot 4.x

## Installation Steps

### 1. Clone Repository
```bash
git clone <repository-url>
cd Jejak-Dua-Dunia
```

### 2. Open in Godot
1. Launch Godot 4.7
2. Click "Open Project"
3. Navigate to `Jejak-Dua-Dunia` folder
4. Select `project.godot`
5. Click "Open & Edit"

### 3. Initial Setup
First time opening the project:
1. Wait for Godot to import all files
2. Check the console for any errors
3. Open `res://ui/main_menu.tscn` to verify setup

## Project Structure

```
res://
├── autoload/              # Global systems (always loaded)
│   ├── event_bus.gd       # Signal hub for game events
│   ├── input_router.gd    # Input handling for 2 players
│   ├── game_state.gd      # Game state and checkpoints
│   ├── scene_manager.gd   # Scene transitions
│   ├── audio_manager.gd   # Audio system with buses
│   ├── save_manager.gd    # Save/load functionality
│   ├── analytics.gd       # Event logging
│   ├── constants.gd       # Game constants
│   └── debug_manager.gd   # Debug utilities
├── actors/                # Game characters
│   ├── player/            # Player scripts and scenes
│   └── enemies/           # Enemy scripts and scenes
├── components/            # Reusable components
│   ├── states/            # State machine states
│   └── *.gd               # Health, Stagger, etc
├── levels/                # Level scenes (babak1/2/3)
├── ui/                    # UI scenes and scripts
├── data/                  # Resource data files (.tres)
├── assets/                # Art, audio, fonts
├── cutscenes/             # Cutscene content
├── project.godot          # Project configuration
└── README.md              # Documentation
```

## Key Systems

### Input System
- **Keyboard (Player 1):** A/D (move), W (jump), F (attack), H (parry), G (taunt), T (finisher)
- **Keyboard (Player 2):** ←/→ (move), ↑ (jump), / (attack), . (dash), ↓ (seed)
- **Gamepad:** Supported for both players
- Remap via OptionsMenu

### Physics Layers
1. World (platforms, obstacles)
2. Raka (player 1 collision)
3. Nisa (player 2 collision)
4. Enemy (enemy collision)
5. PlayerHitbox (player attack areas)
6. EnemyHitbox (enemy damage areas)
7. Projectile (projectile collision)
8. Interactive (tuas, seeds, portals)

### Data & Tuning
All game values are stored as Resource files (.tres):
- `data/raka_data.tres` - Raka stats
- `data/nisa_data.tres` - Nisa stats
- `data/archer_data.tres` - Archer enemy
- `data/swordsman_data.tres` - Swordsman enemy
- `data/golemkala_data.tres` - Boss stats
- `data/wave1/2/3_data.tres` - Wave configs

Edit these files in Inspector to adjust game feel without coding.

### Game Loop
1. **Input** → InputRouter detects button presses
2. **Update** → Player/Enemy states process input
3. **Physics** → CharacterBody2D moves
4. **Collision** → Hitbox/Hurtbox detect damage
5. **Events** → EventBus signals update UI/systems
6. **Render** → Engine displays frame

## Development Workflow

### Creating a Scene
1. Create new scene in `res://levels/` or `res://actors/`
2. Add root node (Node2D for levels, CharacterBody2D for actors)
3. Add child nodes (sprites, colliders, etc)
4. Attach scripts from components/

### Adding a New Ability
1. Create new state in `components/states/ability_state.gd`
2. Extend `State` class
3. Override `enter()`, `exit()`, `update()`, `physics_update()`
4. Add to StateMachine in player/enemy scene
5. Call `transition_to("ability_state")` from input/behavior

### Playtesting & Balance
1. Edit values in `.tres` files
2. No rebuild needed - changes apply on next run
3. Use DebugManager for logs and metrics
4. Check console for event logs

## Debug Features

### Console Commands
- `DebugManager.log("message")` - Print debug message
- `DebugManager.start_timer("name")` - Start performance timer
- `DebugManager.end_timer("name")` - End and log timer
- `DebugManager.print_performance_report()` - Show metrics

### Debug Mode
Set `debug_manager.enable_debug_logs = true` in Inspector to see all events logged.

## Build & Export

### Windows Build
1. Project → Export
2. Select "Windows Desktop"
3. Configure export settings
4. Export as executable

### Web Build
1. Project → Export
2. Select "Web"
3. Configure export settings
4. Export to folder

## Common Issues & Solutions

### Problem: Input not working
**Solution:** Check InputRouter setup in autoload. Verify input actions in Project Settings → Input Map.

### Problem: Camera not following players
**Solution:** Ensure DualTargetCamera is attached to main camera node in level scene.

### Problem: Enemy not spawning
**Solution:** Check WaveManager configuration and enemy scene references.

### Problem: Assets not loading
**Solution:** Verify asset paths in scene files. Check for import errors in Output console.

## Performance Tips

1. Use object pooling for frequently spawned objects (arrows, particles)
2. Cache node references instead of `get_node()` every frame
3. Use `groups` for quick node queries
4. Profile with DebugManager.enable_performance_logs
5. Monitor frame time in Debugger

## Best Practices

1. **Keep states small** - One state per action
2. **Use signals** - Avoid direct node references
3. **Tune via resources** - Don't hardcode values
4. **Test early** - Playtest new features immediately
5. **Comment complex code** - Future you will thank you
6. **Commit often** - Small, focused commits

## Team Guidelines

### Naming Conventions
- Scripts: `snake_case.gd`
- Classes: `PascalCase` (using `class_name`)
- Functions/variables: `snake_case`
- Constants: `UPPER_SNAKE_CASE`
- Groups: `lowercase_no_spaces`

### File Organization
- One class per file (except helpers)
- Scene files match script names
- Resources in `data/` folder
- Keep each folder focused on one responsibility

### Git Workflow
1. Create feature branch: `git checkout -b feature/ability-name`
2. Commit frequently with clear messages
3. Push to remote: `git push origin feature/ability-name`
4. Create PR for review
5. Merge when approved

## Useful Resources

- [Godot 4.x Documentation](https://docs.godotengine.org/en/stable/)
- [GDScript Reference](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/)
- [2D Physics Guide](https://docs.godotengine.org/en/stable/tutorials/physics/using_2d_characters/index.html)
- [Signals Tutorial](https://docs.godotengine.org/en/stable/tutorials/step_by_step/signals.html)

## Support

For questions or issues:
1. Check TODO.md for current status
2. Review DEVLOG.md for previous solutions
3. Search GitHub issues
4. Ask in team chat or documentation

---
**Last Updated:** 19 November 2026
**Project Phase:** Fase 1 - Fondasi
