# Jejak Asa: Dua Arah Pulang - TODO List

## Fase 1: Fondasi ⏳ (In Progress)

### Core Systems ✅
- [x] Struktur direktori proyek
- [x] Autoload systems (EventBus, InputRouter, GameState, dll)
- [x] Component system (Health, Stagger, Hitbox, Hurtbox)
- [x] State machine system
- [x] Data resources (PlayerData, EnemyData, WaveData)

### Player Implementation 🔄
- [x] PlayerBase script
- [x] Raka character script
- [x] Nisa character script
- [x] Player states (Idle, Run, Jump, Fall, Attack, Parry, Dash, Taunt, Finisher, Hurt, Down, Dead)
- [ ] Raka scene file (.tscn)
- [ ] Nisa scene file (.tscn)
- [ ] Player sprites/animations
- [ ] Player collision shapes

### Enemy Implementation 🔄
- [x] EnemyBase script
- [x] ArcherEnemy script
- [x] SwordmanEnemy script
- [x] BossGolemkala script
- [x] ArrowProjectile script
- [ ] Enemy scene files (.tscn)
- [ ] Enemy sprites/animations
- [ ] Enemy collision shapes
- [ ] Enemy AI states

### Testing Arena 📝
- [ ] Create test_arena.tscn
- [ ] Add player spawn points
- [ ] Add test platforms
- [ ] Add enemy spawn points
- [ ] Test movement mechanics
- [ ] Test combat mechanics
- [ ] Test camera system

## Fase 2: Boss Slice 📝

### Babak 2 - Reruntuhan Penempa Jiwa
- [ ] Create babak2.tscn
- [ ] Design arena layout
- [ ] Implement puzzle tuas mechanism
- [ ] Implement Golemkala fase 1 attacks (Slam, Charge)
- [ ] Implement Golemkala fase 2 attacks (+ Projectile Volley)
- [ ] Implement Golemkala fase 3 (faster patterns)
- [ ] Implement Rantai Jangkar mechanic
- [ ] Add telegraphing visuals (zona merah, tanda seru)
- [ ] Add boss HP bar UI
- [ ] Add phase transition effects
- [ ] Add checkpoint system
- [ ] Playtest and balance

## Fase 3: Babak Lainnya 📝

### Babak 1 - Hutan Kehancuran
- [ ] Create babak1.tscn
- [ ] Implement wave spawner system
- [ ] Create 3 gelombang musuh
- [ ] Implement seed planting mechanic
- [ ] Implement Perisai Akar (Raka)
- [ ] Implement Benih Kehidupan (Nisa)
- [ ] Add tunas grow visual feedback
- [ ] Add portal activation
- [ ] Tutorial integration

### Babak 3 - Bukit Lentera
- [ ] Create babak3.tscn
- [ ] Implement auto-scroller mechanic
- [ ] Implement layangan controls (Raka)
- [ ] Implement tameng angin + tembakan (Nisa)
- [ ] Add Bayangan Kehampaan chaser
- [ ] Add obstacle/hazards
- [ ] Add sync boost mechanic
- [ ] Add countdown finale input

## Fase 4: Narasi & UI 📝

### Cutscenes & Dialog
- [ ] Write prolog dialog
- [ ] Write epilog dialog
- [ ] Write inter-babak dialogs
- [ ] Create prolog cutscene
- [ ] Create epilog cutscene
- [ ] Add character portraits
- [ ] Add background illustrations
- [ ] Implement dialog system integration

### UI Polish
- [ ] Design main menu layout
- [ ] Design HUD layout
- [ ] Add HP bars visual
- [ ] Add cooldown indicators
- [ ] Add combo counter
- [ ] Add context prompts ("Tekan T!")
- [ ] Add stagger bar for enemies
- [ ] Add off-screen player indicators
- [ ] Polish pause menu
- [ ] Polish options menu
- [ ] Polish results screen

### Tutorial
- [ ] Integrate tutorial in Babak 1
- [ ] Add movement tutorial
- [ ] Add combat tutorial
- [ ] Add ability tutorial
- [ ] Add co-op mechanic tutorial

## Fase 5: Polish 📝

### Audio
- [ ] Add background music (Babak 1, 2, 3)
- [ ] Add menu music
- [ ] Add boss music
- [ ] Add SFX (parry, dash, attack, jump)
- [ ] Add impact SFX
- [ ] Add ambient sounds
- [ ] Add UI sounds
- [ ] Implement audio mixing

### Visual Effects
- [ ] Add hit particles
- [ ] Add parry spark effect
- [ ] Add dash trail effect
- [ ] Add finisher impact effect
- [ ] Add stagger visual effect
- [ ] Add plant grow particles
- [ ] Add portal particles
- [ ] Add boss attack telegraphs

### Game Feel
- [ ] Implement hitstop on attacks
- [ ] Implement screen shake on impacts
- [ ] Add camera punch on big hits
- [ ] Polish animation transitions
- [ ] Add hurt/invincibility flash
- [ ] Add combo hit feedback

### Balancing
- [ ] Balance player damage values
- [ ] Balance enemy HP and damage
- [ ] Balance boss phases difficulty
- [ ] Balance cooldown timings
- [ ] Balance wave spawn rates
- [ ] Playtest dengan 10+ pairs
- [ ] Adjust based on feedback

## Fase 6: Freeze & Submit 📝

### Bug Fixes
- [ ] Fix all critical bugs
- [ ] Fix soft-locks
- [ ] Fix collision issues
- [ ] Fix input issues
- [ ] Fix camera bugs
- [ ] Fix UI bugs

### Build & Export
- [ ] Create Windows build
- [ ] Test Windows build on clean machine
- [ ] Create Web build
- [ ] Test Web build in browser
- [ ] Optimize file size
- [ ] Add game icon
- [ ] Test on minimum specs

### Submission Package
- [ ] Prepare GDD/PRD document
- [ ] Record gameplay trailer
- [ ] Capture screenshots
- [ ] Write game description
- [ ] List team credits
- [ ] Document asset licenses
- [ ] Upload to itch.io
- [ ] Submit to Gimersia

## Catatan Prioritas
- **MUST HAVE**: Babak 2 boss harus sempurna
- **SHOULD HAVE**: Babak 1 dan 3 boleh lebih pendek
- **Feature Freeze**: 7 hari sebelum deadline
- **Polish Priority**: Babak 2 → Babak 1 → Babak 3
