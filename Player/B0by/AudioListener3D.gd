extends AudioListener3D

@export var player: CharacterBody3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = player.global_position
	pass
