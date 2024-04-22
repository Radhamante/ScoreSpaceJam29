extends AudioStreamPlayer

const music = preload("res://Assets/Sounds/Music/Menu.mp3")

func _play_music(music: AudioStream):
	if stream == music:
		return
	
	stream = music
	play()

func play_music():
	_play_music(music)

func stop_music():
	stream = null


func _on_finished():
	play()
	pass # Replace with function body.
