extends Control

func _ready() -> void:
	var i = 0
	while i <= 100:
		$TabContainer/Audio/masterVol.add_item(str(i))
		$TabContainer/Audio/MusicVol.add_item(str(i))
		$TabContainer/Audio/sfxVol.add_item(str(i))
		i = i+1
	$TabContainer/Audio/masterVol.select(GlobalValues.masterVol)
	$TabContainer/Audio/MusicVol.select(GlobalValues.musicVol)
	$TabContainer/Audio/sfxVol.select(GlobalValues.sfxVol)

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/main_menu.tscn")


func _on_sfx_vol_item_selected(index: int) -> void:
	AudioServer.set_bus_volume_db(2, index)
	GlobalValues.sfxVol = index


func _on_music_vol_item_selected(index: int) -> void:
	AudioServer.set_bus_volume_db(1, index)
	GlobalValues.musicVol = index


func _on_master_vol_item_selected(index: int) -> void:
	AudioServer.set_bus_volume_db(0, index)
	GlobalValues.masterVol = index
