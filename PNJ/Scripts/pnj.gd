extends CharacterBody3D

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
var timer: Timer

var rng = RandomNumberGenerator.new()
var isDrunk = randi() % 2

func _ready():
	timer = Timer.new()
	timer.set_wait_time(3)
	add_child(timer)
	timer.timeout.connect(_choose_action)
	timer.start()

func _choose_action():
	var action = rng.randi_range(1,3)
	
	animation_tree.set("parameters/conditions/idle", false)
	animation_tree.set("parameters/conditions/walk", false)
	animation_tree.set("parameters/conditions/dance", false)
	animation_tree.set("parameters/conditions/hit", false)
	
	# IDLE
	if action == 1:
		animation_tree.set("parameters/conditions/idle", true)
	# WALK
	elif action == 2:
		animation_tree.set("parameters/conditions/walk", true)
		if isDrunk:
			animation_tree.set("parameters/walk/conditions/d_walk", true)
			animation_tree.set("parameters/walk/conditions/n_walk", false)
		else:
			animation_tree.set("parameters/walk/conditions/d_walk", false)
			animation_tree.set("parameters/walk/conditions/n_walk", true)
	#DANCE
	elif action == 3:
		animation_tree.set("parameters/conditions/dance", true)
		animation_tree.set("parameters/dance/conditions/dance_1", false)
		animation_tree.set("parameters/dance/conditions/dance_2", false)
		animation_tree.set("parameters/dance/conditions/dance_3", false)
		animation_tree.set("parameters/dance/conditions/dance_"+str(rng.randi_range(1,3)), true)

func collide():
	animation_tree.set("parameters/conditions/idle", false)
	animation_tree.set("parameters/conditions/walk", false)
	animation_tree.set("parameters/conditions/dance", false)
	animation_tree.set("parameters/conditions/hit", true)
	

var target_velocity = Vector3.ZERO
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state_machine.get_current_node() == "walk":
		if target_velocity == Vector3.ZERO:
			
			var signe1 = [-1, 1].pick_random()  # Choix aléatoire de -1 ou 1 pour le signe du premier nombre
			var signe2 = [-1, 1].pick_random()  # Choix aléatoire de -1 ou 1 pour le signe du deuxième nombre
			var nombre1 = signe1 * randf_range(0, .7)  # Génère un nombre aléatoire entre 0 et 1 puis le multiplie par le signe
			var nombre2 = signe2 * (1.4 - abs(nombre1))  # Calcul du deuxième nombre pour que la somme de leurs valeurs absolues soit 2
			
			target_velocity = Vector3(nombre1,0, nombre2)
			look_at(global_position - target_velocity)
			rotation.x = 0
	else:
		target_velocity = Vector3.ZERO
	velocity = lerp(velocity, target_velocity, 0.05)
	var collider = move_and_collide(velocity * delta)
	if collider:
		if collider.get_collider().has_method("collide"):
			collider.get_collider().collide()
		target_velocity = Vector3.ZERO
		collide()
