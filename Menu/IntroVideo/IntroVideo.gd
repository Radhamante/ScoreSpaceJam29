extends Control

func _ready():
	MenuMusic.stop_music()

func _on_video_stream_player_finished():
	get_tree().change_scene_to_packed(Preloads.level_scene)

