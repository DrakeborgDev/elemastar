extends Node2D

func _load_skills(where: Node, list):
	var dir = "res://JSON/Player_Abilites/"
	print("\n")
	for skillFile in DirAccess.get_files_at(dir):
		var json = JSON.new()
		var _found = false
		var skillAsText = FileAccess.get_file_as_string(dir+skillFile)
		var skillAsDict = json.parse(skillAsText)
		print(str(skillFile))
		if skillAsDict == OK:
			var data = json.data
			print(list)
			for item in list:
				if item == data.name:
					where.add_child(Button.new())
					for child in where.get_children():
						if child is Button:
							if child.text == "":
								child.text = data.name
								child.connect("pressed", _toggle_equipped)
								print("Added " + data.name)
				else:
					pass
		else:
			print("JSON Parse Error: ", json.get_error_message(), " in ", skillFile, ".json at line ", json.get_error_line())

func _ready() -> void:
	_load_skills(%equipedSkills, GlobalValues.equipped)
	_load_skills(%SkillContainer, GlobalValues.unlocked)

func _toggle_equipped():
	var found_clicked = false
	for button in get_node("HSplitContainer/SkillContainer").get_children():
		if button is Button:
			if button.is_pressed():
				found_clicked = true
				print("Equiping " + button.text)
				button.reparent(get_node("HSplitContainer/equipedSkills"))
	if !found_clicked:
		for button in get_node("HSplitContainer/equipedSkills").get_children():
			if button is Button:
				if button.is_pressed():
					found_clicked = true
					print("Unequiping " + button.text)
					button.reparent(get_node("HSplitContainer/SkillContainer"))
	pass

func _on_back_pressed() -> void:
	GlobalValues.equipped = []
	GlobalValues.unlocked = []
	for skill in get_node("HSplitContainer/SkillContainer").get_children():
		if skill is Button:
			GlobalValues.unlocked.append(skill.text)
	for skill in get_node("HSplitContainer/equipedSkills").get_children():
		if skill is Button:
			GlobalValues.equipped.append(skill.text)
	if GlobalValues.equipped == []:
		GlobalValues.equipped = ["Punch"]
		GlobalValues.unlocked.erase("Punch")
	print(str(GlobalValues.equipped))
	get_tree().change_scene_to_file("res://menus/hub_menu.tscn")
