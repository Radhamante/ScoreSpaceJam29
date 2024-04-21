extends Control

func _on_start_pressed():
	get_tree().change_scene_to_packed(Preloads.level_scene)


func _on_leaderboard_pressed():
	get_tree().change_scene_to_packed(Preloads.leaderboard_scene)


func _on_credits_pressed():
	get_tree().change_scene_to_packed(Preloads.credit_scene)


func _on_settings_pressed():
	get_tree().change_scene_to_packed(Preloads.setting_scene)
