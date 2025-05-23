extends Node2D

var availableSkills

func _check_skills(ownedSkills):
	for file in DirAccess.get_files_at("res://JSON/Player_Abilites"):
		var curPath = "res://JSON/Player_Abilites/"+file
		var curfile_as_text = FileAccess.get_file_as_string(curPath)
		var json = JSON.new()
		var curFile_as_dict = json.parse(curfile_as_text)
		if curFile_as_dict == OK:
			var data = json.data
			var exclude = false
			if data.name in ownedSkills:
				exclude = true
			if data in availableSkills:
				exclude = true
			if "parent" in data: 
				if data.parent in ownedSkills:
					pass
				else:
					exclude = true

			if !exclude:
				%purchasable.add_child(Button.new())
				availableSkills.append(data)
				for child in %purchasable.get_children():
					if child is Button:
						if child.text == "":
							child.text = data.name
							child.connect("pressed", _purchase_attempt)
							child.tooltip_text = "This skill costs " + str(int(data.unlock)) + " Bittergems"
							print("Added " + data.name)
		else:
			print("JSON Parse Error: ", json.get_error_message(), " in ", file, " at line ", json.get_error_line())

func _ready() -> void:
	%Heal.text = "heal for " + str(int(GlobalValues.playerMaxHealth - GlobalValues.playerCurentHealth)) + "hp?"
	var ownedSkills = GlobalValues.equipped.duplicate()
	ownedSkills.append_array(GlobalValues.unlocked.duplicate())
	availableSkills = []
	_check_skills(ownedSkills)
	%GemCount.text = "You have " + str(int(GlobalValues.bittergems)) + " Bittergems"


func _purchase_attempt():
	for button in get_node("%purchasable").get_children():
		if button is Button:
			if button.is_pressed():
				for dict in availableSkills:
					if button.text == dict.name:
						if GlobalValues.bittergems >= dict.unlock:
							print("Unlocking " + button.text)
							GlobalValues.unlocked.append(dict.name)
							GlobalValues.bittergems -= dict.unlock
							%GemCount.text = "You have " + str(int(GlobalValues.bittergems)) + " Bittergems"
							var ownedSkills = GlobalValues.equipped.duplicate()
							ownedSkills.append_array(GlobalValues.unlocked.duplicate())
							button.queue_free()
							_check_skills(ownedSkills)
						else:
							print("Not enough Bittergems")
					else:
						pass
						#print(str(dict))

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/hub_menu.tscn")


func _on_heal_pressed() -> void:
	if GlobalValues.playerCurentHealth < GlobalValues.playerMaxHealth:
		if GlobalValues.bittergems >= 2:
			GlobalValues.bittergems -= 2
			GlobalValues.playerCurentHealth += int(GlobalValues.playerMaxHealth - GlobalValues.playerCurentHealth)
		else:
			print("not enough bittergems")
	else:
		print("already full on health")
	%Heal.text = "heal for " + str(int(GlobalValues.playerMaxHealth - GlobalValues.playerCurentHealth)) + "hp?"


func _on_equip_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/skills.tscn")
