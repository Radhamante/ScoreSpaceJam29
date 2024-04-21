extends Node

var scoreRunning: bool = true

var seconds: float = 0.0
var min: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func start_score():
	scoreRunning = true
	
func stop_score():
	scoreRunning = false
	
func reset_score():
	seconds = 0.0
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if scoreRunning:
		seconds += delta
	if seconds >= 59.99:
		min += 1
		reset_score()
