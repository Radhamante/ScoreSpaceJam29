extends Area3D

@export var player: CharacterBody3D

signal boby_entered(boby: CharacterBody3D, area: Area3D)

func _on_body_entered(body):
	if body == player:
		boby_entered.emit(player, self)
