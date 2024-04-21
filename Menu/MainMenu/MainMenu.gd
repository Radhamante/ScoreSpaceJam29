extends Control

const leaderboard_scene = preload("res://Menu/Leaderboard/Leaderboard.tscn")
const credit_scene = preload("res://Menu/Credits/Credits.tscn")
const setting_scene = preload("res://Menu/Settings/Settings.tscn")
const level_scene = preload("res://Levels/Level1.tscn")

func _on_start_pressed():
	get_tree().change_scene_to_packed(level_scene)


func _on_leaderboard_pressed():
	get_tree().change_scene_to_packed(leaderboard_scene)


func _on_credits_pressed():
	get_tree().change_scene_to_packed(credit_scene)


func _on_settings_pressed():
	get_tree().change_scene_to_packed(setting_scene)
