extends CharacterBody3D


const SPEED = 5.0

func _physics_process(delta: float) -> void:

	move_and_slide()
