extends Control

@export var pnjSounds: AudioStreamPlayer

func _ready():
	MenuMusic.play_music()

func _on_back_pressed():
	get_tree().change_scene_to_file("res://Menu/MainMenu/MainMenu.tscn")


func _on_button_2_pressed():
	
	pnjSounds.play()
	pass # Replace with function body.
