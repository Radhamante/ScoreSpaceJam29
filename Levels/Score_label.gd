extends Label

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var score_seconds = snapped(ScoreManager.seconds, 0.02)

	if score_seconds < 10:
		text = ("0%s" %str(score_seconds))
	elif score_seconds >= 10:
		text = str(score_seconds)
