extends Node

@export var camera: Camera3D

var roomSize = 19
var camera_target_position: Vector3 

@export var normal: AudioStreamPlayer
@export var bath: AudioStreamPlayer
@export var out: AudioStreamPlayer

var currentMusicIndex = 0
@onready var musiqueOrder = [bath, normal, out]

# Called when the node enters the scene tree for the first time.
func _ready():
	MenuMusic.stop_music()
	ScoreManager.reset_score()
	ScoreManager.start_score()
	camera_target_position = camera.position

	
func move_camera():
	camera_target_position.x += roomSize

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	camera.position = lerp(camera.position, camera_target_position, 0.1)
	if currentMusicIndex > 0:
		musiqueOrder[currentMusicIndex-1].volume_db = lerpf(musiqueOrder[currentMusicIndex-1].volume_db, -80, .01)
		musiqueOrder[currentMusicIndex].volume_db = lerpf(musiqueOrder[currentMusicIndex].volume_db, 0, .1)

func _on_area_3d_boby_entered(boby, area):
	move_camera()
	#musiqueOrder[currentMusicIndex].volume_db = -80
	currentMusicIndex += 1
	#musiqueOrder[currentMusicIndex].volume_db = 0
	area.position.x += roomSize
	pass # Replace with function body.
