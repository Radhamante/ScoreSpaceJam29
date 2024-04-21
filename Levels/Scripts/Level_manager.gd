extends Node

@export var camera: Camera3D

var roomSize = 17
var camera_target_position: Vector3 

# Called when the node enters the scene tree for the first time.
func _ready():
	camera_target_position = camera.position
	
func move_camera():
	camera_target_position.x += roomSize

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	camera.position = lerp(camera.position, camera_target_position, 0.1)
	pass

func _on_area_3d_boby_entered(boby, area):
	move_camera()
	area.position.x += roomSize
	pass # Replace with function body.
