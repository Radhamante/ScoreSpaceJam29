extends AudioStreamPlayer3D

var cooldown = randi_range(0,15)

func _process(delta):
	if cooldown > 0.0:
		cooldown -= delta
	else:
		play()
		cooldown = randi_range(10,15)
