extends Node2D


func _on_settings_pressed() -> void:
	print("Opening Settings")
	get_tree().change_scene_to_file("res://menus/settings.tscn")


func _on_start_pressed() -> void:
	print("Starting Game")
	get_tree().change_scene_to_file("res://menus/hub_menu.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
