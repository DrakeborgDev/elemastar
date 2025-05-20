extends Node2D


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/hub_menu.tscn")
	#for curFile in DirAccess.get_files_at("res://JSON/Player_Abilites"):
		#var curPath = "res://JSON/Player_Abilites/"+curFile
		#var curfile_as_text = FileAccess.get_file_as_string(curPath)
		#var json = JSON.new()
		#var curFile_as_dict = json.parse(curfile_as_text)
		#if curFile_as_dict == OK:
			#var storedData = []
			#var data = json.data
			#storedData.append(data.name)
			#storedData.append(data.type)
			#var property
			#if "active" in data:
				#storedData.append("active")
				#property = data.active
			#elif "passive" in data:
				#storedData.append("passive")
				#property = data.passive
			#storedData.append(property)
			#GlobalValues.allSkills.append(storedData)
		#else:
			#print("JSON Parse Error: ", json.get_error_message(), " in ", curFile, " at line ", json.get_error_line())
	#print(GlobalValues.allSkills)
