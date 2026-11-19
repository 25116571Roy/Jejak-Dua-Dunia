# Jejak Asa: Dua Arah Pulang

Game 2D co-op lokal untuk dua pemain dengan perpaduan aksi dan platformer.

## Struktur Proyek

```
res://
├── autoload/          # GameState, AudioManager, InputRouter, SceneManager
├── actors/
│   ├── player/        # player_base.tscn, raka.tscn, nisa.tscn
│   └── enemies/       # archer.tscn, swordsman.tscn, golemkala.tscn
├── components/        # health, hitbox, hurtbox, stagger, state_machine
├── levels/            # babak1.tscn, babak2.tscn, babak3.tscn
├── ui/                # hud, dialog_box, menu, pause
├── data/              # *.tres (PlayerData, EnemyData, WaveData)
├── cutscenes/         # Prolog, epilog, dialog scenes
└── assets/
    ├── art/
    │   ├── characters/
    │   ├── enemies/
    │   ├── environment/
    │   ├── ui/
    │   └── vfx/
    ├── audio/
    │   ├── music/
    │   ├── sfx/
    │   └── voice/
    └── fonts/
```

## Teknologi

- Engine: Godot 4.7
- Bahasa: GDScript
- Renderer: GL Compatibility
- Target Platform: Windows (utama), Web (cadangan)

## Status Pengembangan

Fase 1: Fondasi - Dalam Progress
