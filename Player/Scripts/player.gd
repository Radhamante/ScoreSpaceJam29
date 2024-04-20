extends CharacterBody3D

@export var camera : Camera3D

var mouse_left_down: bool = false
func _input( event ):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.is_pressed():
			mouse_left_down = true
		elif event.button_index == 1 and not event.is_pressed():
			mouse_left_down = false
			
func get_mouse_position():
	var mouse_position = get_viewport().get_mouse_position()
	
	var spaceState = get_world_3d().direct_space_state
	var rayOrigin = camera.project_ray_origin(mouse_position)
	var rayEnd = rayOrigin + camera.project_ray_normal(mouse_position) * 2000
	
	var rayQuery = PhysicsRayQueryParameters3D.new()
	rayQuery.from = rayOrigin
	rayQuery.to = rayEnd
	
	var rayArray = spaceState.intersect_ray(rayQuery)
	
	if rayArray.has("position"):
		return rayArray["position"]

func _process( some_change ):
	if mouse_left_down:
		var mousePos = get_mouse_position()
		if mousePos != null:
			look_at(mousePos, Vector3.UP)
			rotation.x = 0
		
		#print(mouse_position)
		#print(position)

const SPEED = 5.0

func _physics_process(delta: float) -> void:

	move_and_slide()
