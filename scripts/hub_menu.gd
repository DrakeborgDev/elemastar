extends Node2D


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/main_menu.tscn")


func _on_battle_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/battle_menus/select.tscn")


func _on_upgrade_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/skills.tscn")


func _on_shop_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/shop.tscn")
