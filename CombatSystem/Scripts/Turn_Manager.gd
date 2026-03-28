extends Node

var party: Array = [Character_Base]
var enemies: Array = [enemy_base]

var turn_queue: Array = []
var current_character

signal player_turn_started(character)
signal enemy_turn_started(character)

# start combat: recupera nemici e personaggi presenti nel party del giocatore.
func start_combat(party_nodes: Array, enemy_nodes: Array):
	party = party_nodes
	enemies = enemy_nodes
	for e in enemies:
		e.set_turn_manager(self)
	
	build_turn_queue()
	next_turn()

# build_turn_queue: funzione che genera i turni definendo chi agisce prima e chi dopo
# utilizzando la speed dei vari personaggi presenti, viene richiamata a inizio combattimento
# e a ogni inizio "ciclo" ovvero quando tutti hanno agito una volta.
func build_turn_queue():
	turn_queue.clear()

	var all_units = party + enemies

	# Tieni solo chi ha speed > 0 e che è vivo, da definire quando 2 valori di spped sono uguali
	turn_queue = all_units.filter(func(u): return u.is_alive() and u.spd > 0)
	turn_queue.sort_custom(func(a, b): return a.spd > b.spd)

# next_turn: funzione di turno, controlla che la battalgia non sia alla fine, chiama
# built_turn_queue se e' vuota (alla fine del ciclo), controlla che il pg corrente sia
# vivo e emette i segnali di azione per player o nemici.
func next_turn():
	if check_battle_end():
		return
	
	if turn_queue.is_empty():
			build_turn_queue()
	
	while turn_queue.size() > 0:
		current_character = turn_queue.pop_front()
		if current_character.is_alive():
			break

	if current_character in party:
		print("tocca al giocatore");
		emit_signal("player_turn_started", current_character)
	else:
		print("tocca al nemico")
		emit_signal("enemy_turn_started", current_character)

func end_turn():
	next_turn()

# check_battle_end: controllo della fine del combattimento, se il party diventa vuoto e'
# game over, se invece i nemici sono finit e' vittoria.
func check_battle_end() -> bool:
	
	var alive_party: Array = [Character_Base]
	var alive_enemies: Array = [enemy_base]
	
	for p in party:
		if p.is_alive():
			alive_party.append(p)
	for e in enemies:
		if e.is_alive():
			alive_enemies.append(e)
	
	if alive_party.is_empty():
		print("GAME OVER")
		return true
	
	if alive_enemies.is_empty():
		print("VICTORY")
		return true
	return false

#func _on_enemy_turn_started(enemy):
	#enemy.take_turn()
