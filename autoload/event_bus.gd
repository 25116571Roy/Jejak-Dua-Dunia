extends Node

#pemain
signal player_down(player_id: int)
signal player_revived(player_id: int)
signal player_used_taunt(player_id: int, posisi: Vector2, radius: float)
signal player_hp_changed(player_id: int, hp_sekarang: float, hp_maks: float)
signal show_prompt(teks: String, player_id: int)
signal play_bark(bark_id: String, player_id: int)

#combat
signal parry_success(player_id: int)
signal weakpoint_hit(musuh: Node, damage: float)
signal enemy_staggered(musuh: Node)
signal enemy_died(musuh: Node)
signal hit_landed(penyerang: Node, target: Node, damage: float)
signal finisher_hit(player_id: int, musuh: Node)

#rantai
signal chain_anchor_connected(anchor: Node)
signal chain_anchor_released(anchor: Node)

#level
signal checkpoint_reached(babak: int, fase: int)
signal level_complete(babak: int)
signal level_failed(babak: int)
signal wave_started(babak: int, gelombang: int)
signal wave_cleared(babak: int, gelombang: int)

#babak1
signal seed_planted(posisi: Vector2)
signal seed_grown(posisi: Vector2)

#audio
signal play_sfx_request(sfx_id: String)
signal play_music_request(music_id: String)
signal stop_music_request()
