extends Node2D

func _load_skills(skill: String, where: String, dir: String = "res://JSON/Player_Abilites/"):
	for skillPath in DirAccess.get_files_at(dir):
		var json = JSON.new()
		var found = false
		var skillAsText = FileAccess.get_file_as_string(dir+skillPath)
		var skillAsDict = json.parse(skillAsText)
		var targetNode = get_node("HSplitContainer/"+where)
		if skillAsDict == OK:
			var data = json.data
			for item in GlobalValues.equipped:
				if item == data.name:
					targetNode.add_child(Button.new())
					for child in targetNode.get_children():
						if child is Button:
							if child.text == "":
								child.text = data.name
								child.connect("pressed", _button_testing)
								print("Added " + data.name)
			for item in GlobalValues.unlocked:
				if item == data.name:
					targetNode.add_child(Button.new())
					for child in targetNode.get_children():
						if child is Button:
							if child.text == "":
								child.text = data.name
								child.connect("pressed", _button_testing)
								print("Added " + data.name)
		else:
			print("JSON Parse Error: ", json.get_error_message(), " in ", skill, ".json at line ", json.get_error_line())

func _ready() -> void:
	for skill in GlobalValues.equipped:
		_load_skills(skill,"equipedSkills")
	for skill in GlobalValues.unlocked:
		_load_skills(skill,"SkillContainer")

func _button_testing():
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
	# TODO don't append the text, append the file-name thats name property matches the text
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
