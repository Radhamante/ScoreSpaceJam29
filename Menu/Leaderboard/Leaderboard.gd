extends Control

@onready var leaderboard: VBoxContainer = $HBoxContainer/VBoxContainer/Scoreboard

# Called when the node enters the scene tree for the first time.
func _ready():
	if not LootLocker.session_token:
		await LootLocker._authentication_request()
	var leader_board = await LootLocker.get_leaderboards()
	var children = leaderboard.get_children()
	for c in children:
		leaderboard.remove_child(c)
		c.queue_free()

	leaderboard.add_child(leader_board)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_back_pressed():
	get_tree().change_scene_to_file("res://Menu/MainMenu/MainMenu.tscn")
