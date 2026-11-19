# Quick Start Guide - Jejak Asa: Dua Arah Pulang

**5 Minute Setup to Get Started**

## Step 1: Open Project (1 min)
```bash
# Navigate to project directory
cd E:\DATA ARNAN\gimersia\Jejak-Dua-Dunia

# Open with Godot 4.7
godot4.7
```

Or:
1. Launch Godot 4.7
2. Click "Open Project"
3. Select `Jejak-Dua-Dunia` folder
4. Click "Open & Edit"

## Step 2: Wait for Import (2 min)
- Godot will import all scripts and resources
- Check "Output" console for any errors
- Should see no red ERROR messages

## Step 3: Verify Setup (1 min)
1. Open FileSystem panel (left)
2. Check that all folders exist:
   - ✅ autoload/ (11 files)
   - ✅ actors/player/ (3 files)
   - ✅ actors/enemies/ (5 files)
   - ✅ components/ (30+ files)
   - ✅ levels/ (babak1.tscn)
   - ✅ ui/ (7 files)
   - ✅ data/ (9 .tres files)

## Step 4: First Task (1 min)
Choose one:

**Option A: Test Existing Setup**
- Open `res://ui/main_menu.tscn`
- Click "Play" (F5)
- Should open main menu scene

**Option B: Create Test Arena**
- Create new scene: Scene → New Scene
- Add Node2D as root
- Name it "TestArena"
- Save as `res://levels/test_arena.tscn`
- Add platform (Rectangle2D with collision)
- Add player (instance from res://actors/player/raka.tscn when ready)

**Option C: View Code**
- Open `res://autoload/event_bus.gd`
- Review all systems in autoload folder
- Check data resource files in `res://data/`

## Common First Steps

### 1. Create Player Scene
```
1. Scene → New Scene → CharacterBody2D
2. Add child: AnimatedSprite2D (for now use Rectangle2D)
3. Add child: CollisionShape2D
4. Add child: StateMachine (from components/)
5. Attach script: res://actors/player/raka.gd
6. Save as: res://actors/player/raka.tscn
```

### 2. Create Enemy Scene
```
1. Scene → New Scene → CharacterBody2D
2. Add child: AnimatedSprite2D (for now use Rectangle2D)
3. Add child: CollisionShape2D
4. Attach script: res://actors/enemies/enemy_base.gd
5. Save as: res://actors/enemies/enemy.tscn
```

### 3. Create Level
```
1. Scene → New Scene → Node2D
2. Add child: TileMap (or Rectangle2D for platforms)
3. Add child: Node2D (name: Players)
   - Add child instances of Raka and Nisa
4. Add child: Node2D (name: Enemies)
   - Add child instances of enemies
5. Add DualTargetCamera script
6. Save as: res://levels/babak1.tscn
```

## Useful Keyboard Shortcuts
- **F5** - Play scene
- **F6** - Play scene from top
- **F8** - Debug breakpoint
- **Ctrl+S** - Save
- **Ctrl+Shift+S** - Save Scene As

## Debugging Tips
1. Open "Output" tab to see all logs
2. Set DebugManager.enable_debug_logs = true in Inspector
3. Use print() statements in scripts
4. Watch variables in Debugger tab during play

## Need Help?
- Check **SETUP.md** for detailed setup
- Check **README.md** for architecture
- Check **TODO.md** for task tracking
- Check **DEVLOG.md** for development notes

## Next Phase
Once scenes are created:
1. Test basic movement
2. Test collision
3. Test camera following
4. Test input handling
5. Proceed to Phase 2: Boss implementation

---
**Status:** Foundation complete, ready for visual implementation! 🚀
