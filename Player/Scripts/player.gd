extends CharacterBody3D

@export var camera : Camera3D

@onready var animation_tree = $AnimationTree
@onready var stateMachine = animation_tree.get("parameters/playback")

@onready var animation_player = $AnimationPlayer

#Speed
@export var maxSpeed: float = 1.1
@export var maxMouseDistance: float = 7.0
var speed = 0

#Movement
var target_velocity = Vector3.ZERO
var isMoving = false
var isHit = false

var mouse_left_down: bool = false

#Timers
var timer: Timer
var rdMov_Timer : Timer
@export var danseTimer: int = 10
@export var staggerTimer: int = 2

func _input( event ):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.is_pressed():
			mouse_left_down = true
		elif event.button_index == 1 and not event.is_pressed():
			mouse_left_down = false
			
func _ready():
	timer = Timer.new()
	timer.set_wait_time(danseTimer)
	timer.set_one_shot(true)
	add_child(timer)
	timer.timeout.connect(dance)
	timer.start()
	
	rdMov_Timer = Timer.new()
	rdMov_Timer.set_wait_time(staggerTimer)
	add_child(rdMov_Timer)
	rdMov_Timer.timeout.connect(random_movement)
	rdMov_Timer.start()
	
func dance():
	animation_tree.set("parameters/conditions/isDancing", true)
			
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
		
func get_mouse_distance(mousePos: Vector3):
	var distance = global_position.distance_to(mousePos)
	return distance
	
func update_anim_condition():
	if isHit == true:
		animation_tree.set("parameters/conditions/isMoving", false)
		animation_tree.set("parameters/conditions/IsIdle", false)
		animation_tree.set("parameters/conditions/isDancing", false)
		animation_tree.set("parameters/conditions/isHiting", true)
		isHit = false
	else :
		if velocity == Vector3.ZERO:
			animation_tree.set("parameters/conditions/isMoving", false)
			animation_tree.set("parameters/conditions/isHiting", false)
			animation_tree.set("parameters/conditions/IsIdle", true)
			if timer.is_stopped(): timer.start()
		else:
			animation_tree.set("parameters/conditions/IsIdle", false)
			animation_tree.set("parameters/conditions/isDancing", false)
			animation_tree.set("parameters/conditions/isHiting", false)
			animation_tree.set("parameters/conditions/isMoving", true)
			timer.stop()
			
func random_movement(mouse_position: Vector3):
	var axis = ["x", "z"]
	var rdAxis = axis.pick_random()
	var distance = get_mouse_distance(mouse_position)
	var rdValue = randf_range(-distance*2, distance*2)
	var offset = Vector3.ZERO

	if rdAxis == "x":
		offset.x += rdValue
	elif rdAxis == "z":
		offset.z += rdValue
	
	return offset

func collide():
	isHit = true

func _process( delta ):
	
	update_anim_condition()
	var animHit = stateMachine.get_current_node()
		
	if mouse_left_down and animHit != "Hit":
		var mousePos = get_mouse_position()

		if mousePos != null and get_mouse_distance(mousePos) < 2.5:
			if get_mouse_distance(mousePos) < 1.5:
				speed = 0
			else:
				speed = get_mouse_distance(mousePos) / 3
			look_at(mousePos, Vector3.UP)
			rotation.x = 0
			target_velocity.x = position.direction_to(mousePos).x * speed
			target_velocity.z = position.direction_to(mousePos).z * speed
			velocity = lerp(velocity, target_velocity, 0.03)
			isMoving = true
			
		elif mousePos != null and get_mouse_distance(mousePos) > 2.5 and isMoving:
			if get_mouse_distance(mousePos) <= maxSpeed:
				speed = maxSpeed 
			if get_mouse_distance(mousePos) > maxMouseDistance:
				velocity = lerp(velocity, Vector3.ZERO, 0.08)
			else:
				look_at(mousePos, Vector3.UP)
				rotation.x = 0
				#mousePos = random_movement(mousePos)
				var offset = random_movement(mousePos)
				target_velocity.x = position.direction_to(mousePos).x * speed
				target_velocity.z = position.direction_to(mousePos).z * speed
				velocity = lerp(velocity, (target_velocity + offset) , 0.03)
			
		if mousePos == null:
			velocity = lerp(velocity, Vector3.ZERO, 0.08)
			if Vector3(-0.1, -0.1, -0.1) < velocity and velocity < Vector3(0.1, 0.1, 0.1):
				velocity = Vector3.ZERO

			isMoving = false

	else:
		velocity = lerp(velocity, Vector3.ZERO, 0.08)
		if Vector3(-0.1, -0.1, -0.1) < velocity and velocity < Vector3(0.1, 0.1, 0.1):
			velocity = Vector3.ZERO
		isMoving = false

	var collider = move_and_collide(velocity * delta)
	
	if collider :
		collide()
		
	if animHit == "Hit":
		timer.stop()


const SPEED = 5.0

func _physics_process(delta: float) -> void:

	move_and_slide()
