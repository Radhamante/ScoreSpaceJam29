extends Control

@onready var leaderboard: VBoxContainer = $HBoxContainer/VBoxContainer/Scoreboard

# Called when the node enters the scene tree for the first time.
func _ready():
	LootLocker._authentication_request()
	var a = await LootLocker.get_leaderboards()
	print("aaaaaa", a)
	leaderboard.add_child(a)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_back_pressed():
	get_tree().change_scene_to_file("res://Menu/MainMenu/MainMenu.tscn")
