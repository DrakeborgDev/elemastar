extends Node2D

var enemyMaxHealth
var equippedAttacks = []

func _ready() -> void:
	print("Region: ", str(GlobalValues.activeRegion), ", Element: ", str(GlobalValues.affinityElement), ", Versing: ", str(GlobalValues.opponent), ", Resetting Affinity Modifier")
	$PlayerDetails/BitterGem.text = "Bittergems: "+str(int(GlobalValues.bittergems))
	$PlayerDetails/XP.text = "XP: "+str(int(GlobalValues.xp))
	$PlayerDetails/Health.text = "Health: "+str(int(GlobalValues.playerCurentHealth)) + "/" + str(int(GlobalValues.playerMaxHealth))
	$EnemyDetails/Affinity.text = GlobalValues.affinityElement + " at strenght " + str(GlobalValues.affinityModifier)
	_load_enemy()
	_load_player_attacks()

func _enemy_attack():
	var attacks = GlobalValues.opponent[1]
	var activeAttack = attacks[randi_range(0, attacks.size()-1)]
	GlobalValues.playerCurentHealth -= _attack_affinity(activeAttack.type, activeAttack.damage)
	if GlobalValues.playerCurentHealth <= 0:
		print("mission failed, you'll get them next time")
		GlobalValues.playerCurentHealth = GlobalValues.playerMaxHealth
		get_tree().change_scene_to_file("res://menus/battle_menus/select.tscn")
	else:
		$PlayerDetails/Health.text = "Health: "+str(int(GlobalValues.playerCurentHealth)) + "/" + str(int(GlobalValues.playerMaxHealth))

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/battle_menus/select.tscn")

func _on_turn_advanced():
	#print(GlobalValues.opponent)
	#print("value " + str(GlobalValues.affinityModifier) + " is " + str(GlobalValues.opponent[GlobalValues.affinityModifier]))
	GlobalValues.affinityModifier += 1
	$EnemyDetails/Health.text = "Health: " + str(int(GlobalValues.opponent[0])) + "/" + str(enemyMaxHealth)
	if GlobalValues.opponent[0] <= 0:
		print("You Win!")
		GlobalValues.xp += GlobalValues.opponent[4].xp
		GlobalValues.bittergems += GlobalValues.opponent[4].bittergem
		GlobalValues.playerCurentHealth += int((GlobalValues.playerMaxHealth - GlobalValues.playerCurentHealth)/2)
		GlobalValues.affinityElement = null
		GlobalValues.opponent = null
		get_tree().change_scene_to_file("res://menus/hub_menu.tscn")
	else:
		$EnemyDetails/Affinity.text = GlobalValues.affinityElement + " at strenght " + str(GlobalValues.affinityModifier)
		_enemy_attack()


func _on_skip_pressed() -> void:
	print(GlobalValues.opponent)
	_on_turn_advanced()

func _attack_affinity(type: String, baseDamage: int) -> int:
	match type:
		GlobalValues.affinityElement:
			print("boosted")
			return  baseDamage + GlobalValues.affinityModifier
		"Force":
			print("unaffected")
			return baseDamage
		_:
			print("diminished")
			var total = baseDamage - GlobalValues.affinityModifier
			if total <= 0:
				return 0
			else:
				return total

func _on_fight_pressed() -> void:
	print(str(int(equippedAttacks[%SelectedSkill.selected].active.damage)))
	
	GlobalValues.opponent[0] -= _attack_affinity(equippedAttacks[%SelectedSkill.selected].type, int(equippedAttacks[%SelectedSkill.selected].active.damage))
	_on_turn_advanced()

func _load_enemy():
	var enemyDir = "res://JSON/Enemies/" + GlobalValues.opponent +".json"
	var curFile_as_text = FileAccess.get_file_as_string(enemyDir)
	var json = JSON.new()
	var curFile_as_dict = json.parse(curFile_as_text)
	if curFile_as_dict == OK:
		var data = json.data
		enemyMaxHealth = int(data.health)
		$EnemyDetails/Name.text = data.name
		$EnemyDetails/Health.text = "Health: " + str(int(data.health)) + "/" + str(enemyMaxHealth)
		GlobalValues.opponent = [data.health] #0
		GlobalValues.opponent.append(data.attacks)#1
		GlobalValues.opponent.append(data.weaknesses)#2
		GlobalValues.opponent.append(data.resistances)#3
		GlobalValues.opponent.append(data.rewards)#4
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", enemyDir, " at line ", json.get_error_line())
		
func _load_player_attacks():
	var abilityDir = "res://JSON/Player_Abilites/"
	for abilityFile in DirAccess.get_files_at(abilityDir):
		var curFile = abilityDir + abilityFile
		var curfile_as_text = FileAccess.get_file_as_string(curFile)
		var json = JSON.new()
		var curFile_as_dict = json.parse(curfile_as_text)
		if curFile_as_dict == OK:
			var data = json.data
			for equipped in GlobalValues.equipped:
				if equipped == data.name:
					print(data.name)
					if "active" in data:
						%SelectedSkill.add_item(data.name)
						equippedAttacks.append(data)
		else:
			print("JSON Parse Error: ", json.get_error_message(), " in ", abilityFile, " at line ", json.get_error_line())
