extends Node

var music_audio_player_count: int = 2
var current_music_player_index: int = -1
var music_players: Array[AudioStreamPlayer] = []
var music_bus: String = "Music"
var music_fade_duration: float = 0.5
var music_fade_volume: float = -40.0

func _ready() -> void:
	for i in music_audio_player_count:
		var audio_stream_player: AudioStreamPlayer = AudioStreamPlayer.new()
		audio_stream_player.name = "audio_player_" + str(i)
		audio_stream_player.bus = music_bus
		audio_stream_player.process_mode = Node.PROCESS_MODE_ALWAYS
		add_child(audio_stream_player)
		music_players.append(audio_stream_player)

func play_music(audio: AudioStream) -> void:
	if current_music_player_index > -1 and audio == music_players[current_music_player_index].stream:
		return
	var free_music_player_index: int = -1	
	for i in music_audio_player_count:
		var mp: AudioStreamPlayer = music_players[i]
		if not mp.playing:
			free_music_player_index = i
			break
	if current_music_player_index > -1:
		var current = music_players.get(current_music_player_index)
		_fade_out(current)
	if free_music_player_index > -1:
		var next = music_players.get(free_music_player_index)
		_fade_in(next, audio)
	current_music_player_index = free_music_player_index

func _fade_in(music_player: AudioStreamPlayer, audio: AudioStream) -> void:
	if not music_player or not audio:
		return
	music_player.stream = audio
	music_player.volume_db = music_fade_volume
	music_player.play()
	var tween: Tween = get_tree().create_tween()
	await tween.tween_property(music_player, "volume_db", 0.0, music_fade_duration).finished

func _fade_out(music_player: AudioStreamPlayer ) -> void:
	if not music_player:
		return
	var tween: Tween = get_tree().create_tween()
	await tween.tween_property(music_player, "volume_db", 0.0, music_fade_duration).finished
	music_player.stop()
