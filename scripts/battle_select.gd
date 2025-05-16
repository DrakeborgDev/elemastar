extends Node2D

func _ready() -> void:
	
	if  GlobalValues.allRegions == []:
		print("No data found, loading new data")
		for curFile in DirAccess.get_files_at("res://JSON/Regions"):
			var curPath = "res://JSON/Regions/"+curFile
			var curFile_as_text = FileAccess.get_file_as_string(curPath)
			var json = JSON.new()
			var curFile_as_dict = json.parse(curFile_as_text)
			if curFile_as_dict == OK:
				var data = json.data
				print(json.get_data())
				%regionSelector.add_item(data.name)
				
				#add the json object to the allRegions list
				GlobalValues.allRegions.append(curFile_as_text)
			else: 
				print("JSON Parse Error: ", json.get_error_message(), " in ", curFile, " at line ", json.get_error_line())
			print(GlobalValues.allRegions)
	else:
		for region in GlobalValues.allRegions:
			var json = JSON.new()
			var _curRegion_as_dict = json.parse(region)
			var data = json.data
			%regionSelector.add_item(data.name)
		print("Reusing previous data")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/hub_menu.tscn")

func _on_fight_pressed() -> void:
	var fightData
	for region in GlobalValues.allRegions:
		var json = JSON.new()
		var _curRegion = json.parse(region)
		var curData = json.data
		if curData.name == %regionSelector.get_item_text(%regionSelector.get_selected_id()):
			print("found The region")
			fightData = curData
	
	var affinitySize
	if fightData.affinities != null:
		affinitySize = fightData.affinities.size()-1
	var enemySize
	if fightData.enemies != null:
		enemySize = fightData.enemies.size()-1
	
	GlobalValues.activeRegion = %regionSelector.get_item_text(%regionSelector.get_selected_id())
	GlobalValues.affinityElement = fightData.affinities[randi_range(0, affinitySize)]
	GlobalValues.opponent = fightData.enemies[randi_range(0, enemySize)]
	GlobalValues.affinityModifier = 0
	#print(fightData)
	print("Region: ", str(GlobalValues.activeRegion), ", Element: ", str(GlobalValues.affinityElement), ", Versing: ", str(GlobalValues.opponent), ", Resetting Affinity Modifier")
	get_tree().change_scene_to_file("res://menus/battle_menus/fight.tscn")
