extends Control


func _on_start_pressed():
	#get_tree().change_scene_to_file()
	pass


func _on_leaderboard_pressed():
	get_tree().change_scene_to_file("res://Menu/Leaderboard/Leaderboard.tscn")


func _on_credits_pressed():
	get_tree().change_scene_to_file("res://Menu/Credits/Credits.tscn")


func _on_exit_pressed():
	pass # Replace with function body.


func _on_settings_pressed():
	get_tree().change_scene_to_file("res://Menu/Settings/Settings.tscn")
