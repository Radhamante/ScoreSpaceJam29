extends Node

var scoreRunning: bool = false
var score: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func start_score():
	scoreRunning = true
	
func stop_score():
	scoreRunning = false
	
func reset_score():
	score = 0.0
	
func get_score():
	return 
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if scoreRunning:
		score += delta
