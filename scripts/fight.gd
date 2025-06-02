extends Node2D

var enemyMaxHealth
var equippedAttacks = []
var equipppedPassives = []
var guardAmount = 0
var guardType = ""

func _ready() -> void:
	print("Region: ", str(GlobalValues.activeRegion), ", Element: ", str(GlobalValues.affinityElement), ", Versing: ", str(GlobalValues.opponent), ", Resetting Affinity Modifier")
	$PlayerDetails/BitterGem.text = "Bittergems: "+str(int(GlobalValues.bittergems))
	$PlayerDetails/XP.text = "XP: "+str(int(GlobalValues.xp))
	$PlayerDetails/Health.text = "Health: "+str(int(GlobalValues.playerCurentHealth)) + "/" + str(int(GlobalValues.playerMaxHealth))
	$EnemyDetails/Affinity.text = GlobalValues.affinityElement + " at strength " + str(GlobalValues.affinityModifier)
	_load_enemy()
	_load_player_attacks()
	await _run_dialog(GlobalValues.affinityElement + " type attacks are boosted this fight")

func _enemy_attack():
	var attacks = GlobalValues.opponent[1]
	var activeAttack = attacks[randi_range(0, attacks.size()-1)]
	var dmg = _attack_affinity(activeAttack.type, activeAttack.damage)
	match guardType:
		activeAttack.type:
			dmg -= 2*guardAmount
		"":
			pass
		_:
			dmg -= guardAmount
	if dmg <= 0:
		dmg = 0
	GlobalValues.playerCurentHealth -= dmg
	guardAmount = 0
	guardType = ""
	await _run_dialog("Opponent deals " + str(dmg) + " " +  activeAttack.type + " damage")
	if GlobalValues.playerCurentHealth <= 0:
		await _run_dialog("mission failed, you'll get them next time")
		GlobalValues.playerCurentHealth = GlobalValues.playerMaxHealth
		get_tree().change_scene_to_file("res://menus/battle_menus/select.tscn")
	else:
		$PlayerDetails/Health.text = "Health: "+str(int(GlobalValues.playerCurentHealth)) + "/" + str(int(GlobalValues.playerMaxHealth))

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/battle_menus/select.tscn")

func _on_turn_advanced():
	if GlobalValues.opponent[0] <= 0:
		$EnemyDetails/Health.text = "Health: 0/" + str(enemyMaxHealth)
		await _run_dialog(str($EnemyDetails/Name.text) + " Defeated")
		await _run_dialog("You Earn " + str(int(GlobalValues.opponent[4].xp)) + " XP and " + str(int(GlobalValues.opponent[4].bittergem)) + " Bittergems")
		GlobalValues.xp += GlobalValues.opponent[4].xp
		GlobalValues.bittergems += GlobalValues.opponent[4].bittergem
		GlobalValues.playerCurentHealth += int((GlobalValues.playerMaxHealth - GlobalValues.playerCurentHealth)/2)
		GlobalValues.affinityElement = null
		GlobalValues.opponent = null
		get_tree().change_scene_to_file("res://menus/hub_menu.tscn")
	else:
		
		_enemy_attack()
		GlobalValues.affinityModifier += 1
		$EnemyDetails/Affinity.text = GlobalValues.affinityElement + " at strength " + str(GlobalValues.affinityModifier)


func _guard() -> void:
	guardType = %guardTypes.get_item_text(%guardTypes.selected)
	guardAmount = 2
	await _run_dialog("You bide your time")
	await _run_dialog("defense against " + guardType + " is boosted for the turn")
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
	
	var selectedAttack = equippedAttacks[%SelectedSkill.selected]
	_check_passives(selectedAttack.type)
	var dmg = _attack_affinity(selectedAttack.type, int(selectedAttack.active.damage) + _check_passives(selectedAttack.type))
	GlobalValues.opponent[0] -= dmg
	$EnemyDetails/Health.text = "Health: " + str(int(GlobalValues.opponent[0])) + "/" + str(enemyMaxHealth)
	await _run_dialog("You deal " + str(dmg) + " " + selectedAttack.type + " damage")
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
					if "passive" in data:
						equipppedPassives.append(data)
		else:
			print("JSON Parse Error: ", json.get_error_message(), " in ", abilityFile, " at line ", json.get_error_line())

func _check_passives(type: String) -> int:
	for passive in equipppedPassives:
		if passive.type == type:
			print(passive.name + " boosted the attack by " + str(int(passive.passive.boost.amount)))
			return int(passive.passive.boost.amount)
	return 0

func _run_dialog(message: String):
	get_tree().paused = true
	%Continue.show()
	print("setting textbox")
	%DialogBox.text = message
	await %Continue.pressed
	%Continue.hide()
	print("clearing textbox")
	%DialogBox.text = ""
	get_tree().paused = false
	return
