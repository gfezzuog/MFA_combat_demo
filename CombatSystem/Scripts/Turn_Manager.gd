extends Node

var turn_queue: Array[Character] = []
var current_character: Character

signal player_turn_started(character)

func start_combat(party: Array, enemies: Array):
	turn_queue = party + enemies
	turn_queue.sort_custom(func(a, b): return a.speed > b.speed)
	next_turn()

func next_turn():
	if turn_queue.is_empty():
		return
	
	current_character = turn_queue.pop_front()
	
	if not current_character.is_alive():
		next_turn()
		return
	
	if current_character.is_in_group("player"):
		emit_signal("player_turn_started", current_character)
	else:
		enemy_action(current_character)

func end_turn():
	turn_queue.append(current_character)
	next_turn()

func enemy_action(enemy: Character):
	# AI semplice
	print(enemy.character_name, " attacca")
	end_turn()
