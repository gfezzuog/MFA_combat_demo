extends enemy_base

# Called when the node enters the scene tree for the first time.
func _ready():
	actions = [
		create_attack_action("Slash", 1.0),
		create_attack_action("Heavy Strike", 1.8),
		#create_heal_action("Recover", 20)
	]
	
	
func create_attack_action(atk_name: String, multiplier: float):
	return{
		"name": atk_name,
		"type":"attack",
		"multiplier": multiplier,
		"target": "enemy"
	}

#func choose_action():
	#if hp < 15:
		#var heals = actions.filter(func(a): return a.type == "heal")
		#if not heals.is_empty():
			#return heals[0]
	#
	#return super.choose_action()
