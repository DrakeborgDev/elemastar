extends Node2D

#func _ready():




func _ready() -> void:
	if GlobalValues.allSkills == []:
		
		for curFile in DirAccess.get_files_at("res://JSON/Player_Abilites"):
			var curPath = "res://JSON/Player_Abilites/"+curFile
			var curfile_as_text = FileAccess.get_file_as_string(curPath)
			var json = JSON.new()
			var curFile_as_dict = json.parse(curfile_as_text)
			if curFile_as_dict == OK:
				var storedData = []
				var data = json.data
				storedData.append(data.name)
				if "parent" in data:
					storedData.append(data.parent)
				else:
					storedData.append(null)
				if "unlock" in data:
					storedData.append(data.unlock)
				else:
					storedData.append(null)
				storedData.append(data.type)
				GlobalValues.allSkills.append(storedData)
			else:
				print("JSON Parse Error: ", json.get_error_message(), " in ", curFile, " at line ", json.get_error_line())
		#print(GlobalValues.allSkills)
	else:
		pass
	
	var i = 0
	for skill in GlobalValues.allSkills:
		var skillName = skill[0]
		var skillParent
		var tooltip
		var _skillCost
		if skill[1] != null:
			skillParent = skill[1]
			tooltip = ("requires " + str(skillParent) + " to be unlocked first")
		else:
			tooltip = ""
		if skill[2] != null:
			_skillCost = skill[2]
		print(skill)
	
		%SkillContainer.add_child(Button.new())
		var curButton = %SkillContainer.get_child(i)
		curButton.text = skillName
		curButton.tooltip_text = tooltip
		curButton.connect("pressed", _button_testing)
		i = i+1

func _button_testing():
	var found_clicked = false
	for button in get_node("HSplitContainer/SkillContainer").get_children():
		if button.is_pressed():
			found_clicked = true
			print(str(button))
			button.reparent(get_node("HSplitContainer/equipedSkills"))
	if !found_clicked:
		for button in get_node("HSplitContainer/equipedSkills").get_children():
			if button.is_pressed():
				found_clicked = true
				print(str(button))
				button.reparent(get_node("HSplitContainer/SkillContainer"))
	pass

func _on_back_pressed() -> void:
	for button in get_node("HSplitContainer/equipedSkills").get_children():
		print(button.text)
	get_tree().change_scene_to_file("res://menus/hub_menu.tscn")
