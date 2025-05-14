extends Node2D


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/hub_menu.tscn")


func _on_fight_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/battle_menus/fight.tscn")
