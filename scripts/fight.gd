extends Node2D

var enemyMaxHealth

func _ready() -> void:
	print("Region: ", str(GlobalValues.activeRegion), ", Element: ", str(GlobalValues.affinityElement), ", Versing: ", str(GlobalValues.opponent), ", Resetting Affinity Modifier")
	$PlayerDetails/BitterGem.text = "Bittergems: "+str(int(GlobalValues.bittergems))
	$PlayerDetails/XP.text = "XP: "+str(int(GlobalValues.xp))
	$PlayerDetails/Health.text = "Health: "+str(int(GlobalValues.playerCurentHealth)) + "/" + str(int(GlobalValues.playerMaxHealth))
	$EnemyDetails/Affinity.text = GlobalValues.affinityElement + " at strenght " + str(GlobalValues.affinityModifier)
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

func _enemy_attack():
	var attacks = GlobalValues.opponent[1]
	var activeAttack = attacks[randi_range(0, attacks.size()-1)]
	match activeAttack.type:
		GlobalValues.affinityElement:
			print("matches")
			GlobalValues.playerCurentHealth -= (activeAttack.damage + GlobalValues.affinityModifier)
		"Force":
			print("no modification")
			GlobalValues.playerCurentHealth -= activeAttack.damage
		_:
			print("did not match")
			if (activeAttack.damage - GlobalValues.affinityModifier) >= 0: 
				GlobalValues.playerCurentHealth -= (activeAttack.damage - GlobalValues.affinityModifier)
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
		GlobalValues.affinityElement = null
		GlobalValues.opponent = null
		get_tree().change_scene_to_file("res://menus/hub_menu.tscn")
	else:
		$EnemyDetails/Affinity.text = GlobalValues.affinityElement + " at strenght " + str(GlobalValues.affinityModifier)
		_enemy_attack()


func _on_skip_pressed() -> void:
	print(GlobalValues.opponent)
	_on_turn_advanced()


func _on_fight_pressed() -> void:
	GlobalValues.opponent[0] -= (1 + GlobalValues.affinityModifier)
	_on_turn_advanced()
