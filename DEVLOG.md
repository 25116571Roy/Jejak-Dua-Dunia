# Jejak Asa: Dua Arah Pulang - Development Log

## Project Structure Created - 2026-11-19

### Directory Structure
- ✅ autoload/ - Game systems (EventBus, InputRouter, GameState, SceneManager, AudioManager, SaveManager, Analytics)
- ✅ actors/player/ - Player characters (Raka, Nisa base scripts)
- ✅ actors/enemies/ - Enemy characters (Base, Archer, Swordsman, Boss Golemkala)
- ✅ components/ - Reusable components (Health, Hitbox, Hurtbox, Stagger, StateMachine, State)
- ✅ levels/ - Level scenes (Babak 1, 2, 3)
- ✅ ui/ - UI elements (HUD, Dialog, Menu, Pause, Results)
- ✅ data/ - Resource data (PlayerData, EnemyData, WaveData)
- ✅ cutscenes/ - Cutscene content
- ✅ assets/ - Art, audio, fonts folders

### Core Systems Implemented

#### Autoload Systems
1. **EventBus** - Central event system for game-wide signals
2. **InputRouter** - Input handling for 2 players (keyboard + gamepad)
3. **GameState** - Game state management, checkpoints, player status
4. **SceneManager** - Scene loading and transitions
5. **AudioManager** - Audio playback with bus management
6. **SaveManager** - Save/load game data and settings
7. **Analytics** - Event logging for playtesting data

#### Components
1. **Health** - HP management with invincibility frames
2. **Stagger** - Stagger system for enemies and players
3. **Hitbox/Hurtbox** - Damage collision detection
4. **StateMachine** - Generic state machine for actors
5. **State** - Base state class
6. **WaveManager** - Wave-based enemy spawning
7. **DualTargetCamera** - Dynamic camera following both players
8. **Portal** - Level transition system
9. **Checkpoint** - Checkpoint system
10. **TutorialManager** - Tutorial step management
11. **ComboSystem** - Combo tracking
12. **SeedPoint** - Planting mechanic for Babak 1

#### Player System
1. **PlayerBase** - Base class with health, abilities, combo
2. **RakaCharacter** - Raka-specific abilities (Parry, Taunt, Finisher)
3. **NisaCharacter** - Nisa-specific abilities (Dash, weakpoint attacks)

#### Enemy System
1. **EnemyBase** - Base enemy with AI, health, stagger
2. **ArcherEnemy** - Ranged enemy with draw/shoot behavior
3. **SwordmanEnemy** - Melee enemy with light/heavy attacks
4. **BossGolemkala** - 3-phase boss with multiple attack patterns
5. **ArrowProjectile** - Projectile for archer enemies

#### Data Resources
1. **PlayerData** - Character stats and abilities (tunable)
2. **EnemyData** - Enemy stats and behavior (tunable)
3. **WaveData** - Wave configuration for spawning

#### UI Systems
1. **MainMenu** - Start screen
2. **ModeSelect** - Choose 2-player or solo mode
3. **HUD** - HP bars, cooldowns, status
4. **DialogBox** - Story dialog with typing effect
5. **PauseMenu** - Pause screen
6. **OptionsMenu** - Settings (volume, fullscreen, vsync)
7. **ResultsScreen** - Level completion stats

### Configuration
- Project configured for Godot 4.7
- GL Compatibility renderer
- 1920x1080 base resolution
- 60 FPS physics tick rate
- 8 physics layers configured
- Input mapping for 2 players

## Next Steps (Following PRD Phases)

### Phase 1 - Foundation (Current)
- [ ] Create player scene files (.tscn)
- [ ] Create enemy scene files (.tscn)
- [ ] Create test arena scene
- [ ] Implement player states (Idle, Run, Jump, Attack, etc)
- [ ] Implement enemy states
- [ ] Test basic movement and combat

### Phase 2 - Boss Slice
- [ ] Implement Golemkala boss mechanics
- [ ] Create Babak 2 level with puzzle
- [ ] Implement all 3 boss phases
- [ ] Polish boss telegraphing

### Phase 3 - Other Levels
- [ ] Complete Babak 1 (wave defense + seed planting)
- [ ] Complete Babak 3 (escape sequence)

### Phase 4 - Narrative & UI
- [ ] Add dialog sequences
- [ ] Create cutscenes (prolog, epilog)
- [ ] Complete tutorial integration
- [ ] Polish all UI screens

### Phase 5 - Polish
- [ ] Add audio (music, SFX)
- [ ] Add VFX particles
- [ ] Implement game feel (hitstop, screen shake)
- [ ] Balancing and playtesting

### Phase 6 - Freeze & Submit
- [ ] Final bug fixes
- [ ] Build Windows executable
- [ ] Build Web version
- [ ] Create trailer
- [ ] Prepare submission package

## Notes
- All values are tunable via Resource files
- Physics layers properly configured
- Input system supports keyboard + gamepad
- Camera follows both players dynamically
- Analytics system ready for playtesting data collection
