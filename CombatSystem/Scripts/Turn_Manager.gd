extends Node

var party: Array = [Character_Base]
var enemies: Array = [enemy_base]

var turn_queue: Array = []
var current_character

signal player_turn_started(character)
signal enemy_turn_started(character)

func start_combat(party_nodes: Array, enemy_nodes: Array):
	party = party_nodes
	enemies = enemy_nodes
	
	build_turn_queue()
	next_turn()

func build_turn_queue():
	turn_queue.clear()

	var all_units = party + enemies

	# Tieni solo chi ha speed > 0 e che è vivo
	turn_queue = all_units.filter(func(u): return u.is_alive() and u.spd > 0)
	turn_queue.sort_custom(func(a, b): return a.spd > b.spd)

func next_turn():
	if check_battle_end():
		return
	
	if turn_queue.is_empty():
			build_turn_queue()
	
	while turn_queue.size() > 0:
		
		current_character = turn_queue.pop_front()
		
		if current_character.is_alive():
			break
	
		#if not current_character.is_alive():
			#next_turn()
			#return
	if current_character in party:
		emit_signal("player_turn_started", current_character)
	else:
		emit_signal("enemy_turn_started", current_character)

func end_turn():
	next_turn()

func check_battle_end() -> bool:
	
	var alive_party: Array = [Character_Base]
	var alive_enemies: Array = [enemy_base]
	
	for p in party:
		if p.is_alive:
			alive_party.append(p)
	for e in enemies:
		if e.is_alive:
			alive_enemies.append(e)
	#var alive_party = party.filter(func(c): return c.is_alive())
	#var alive_enemies = enemies.filter(func(c): return c.is_alive())
	
	if alive_party.is_empty():
		print("GAME OVER")
		return true
	
	if alive_enemies.is_empty():
		print("VICTORY")
		return true
	
	return false
