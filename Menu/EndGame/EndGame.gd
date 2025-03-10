extends Control


@export var name_input: LineEdit
@export var score_label: Label

# Called when the node enters the scene tree for the first time.
func _ready():
	MenuMusic.play_music()
	ScoreManager.stop_score()
	LootLocker.score = (ScoreManager.min * 60 + ScoreManager.seconds) * 1000
	_send()
	score_label.text = LootLocker.convert_time(LootLocker.score / 1000)
	
	pass # Replace with function body.

func _send():
	LootLocker.player_name = name_input.text
	LootLocker._upload_score()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_line_edit_text_submitted(new_text):
	_send()



func _on_leaderboard_pressed():
	get_tree().change_scene_to_packed(Preloads.leaderboard_scene)
	pass # Replace with function body.


func _on_main_menu_pressed():
	get_tree().change_scene_to_packed(Preloads.mainmenu_scene)
	pass # Replace with function body.
