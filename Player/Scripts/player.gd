extends CharacterBody3D


var mouse_left_down: bool = false
func _input( event ):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.is_pressed():
			mouse_left_down = true
		elif event.button_index == 1 and not event.is_pressed():
			mouse_left_down = false
func _process( some_change ):
	if mouse_left_down:
		var mouse_position = get_viewport().get_mouse_position()
		print(mouse_position)
		print(position)

const SPEED = 5.0

func _physics_process(delta: float) -> void:

	move_and_slide()
