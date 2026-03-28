extends Node

#func _ready() -> void:
	#$fire.pressed.connect(on_button_pressed.bind(enemy_base.ELEMENTS.FIRE))
	#$water.pressed.connect(on_button_pressed.bind(enemy_base.ELEMENTS.WATER))
	#$wind.pressed.connect(on_button_pressed.bind(enemy_base.ELEMENTS.WIND))
	#$earth.pressed.connect(on_button_pressed.bind(enemy_base.ELEMENTS.EARTH))
	#$holy.pressed.connect(on_button_pressed.bind(enemy_base.ELEMENTS.HOLY))
	#$profane.pressed.connect(on_button_pressed.bind(enemy_base.ELEMENTS.PROFANE))
	#
	#pass # Replace with function body.
#
#func on_button_pressed(element):
	#$AngelicDinosaur.apply_element(element)

@onready var turn_manager = $TurnManager
@onready var turn_status = $TurnStatus
@onready var next_turn_button = $nextTurn

@onready var player1 = $Party/Character1
@onready var player2 = $Party/Character2
@onready var player3 = $Party/Character3
@onready var player4 = $Party/Character4

@onready var status_label_player1 = $Party/Character1/PlayerStatus1
@onready var status_label_player2 = $Party/Character2/PlayerStatus2
@onready var status_label_player3 = $Party/Character3/PlayerStatus3
@onready var status_label_player4 = $Party/Character4/PlayerStatus4

@onready var action_menu = $ActionMenu
var current_target = null

func _ready():
	var party_nodes = $Party.get_children()
	var enemy_nodes = $Enemies/AngelicDinosaur.get_children()
	turn_manager.player_turn_started.connect(_on_player_turn)
	turn_manager.enemy_turn_started.connect(_on_enemy_turn)
	turn_manager.start_combat(party_nodes, enemy_nodes)

func _process(_delta) -> void:
	status_label_player1.text = player1.character_name + "\nHP: " + str(player1.hp) + "/" + str(player1.max_hp)
	status_label_player2.text = player2.character_name + "\nHP: " + str(player2.hp) + "/" + str(player2.max_hp)
	status_label_player3.text = player3.character_name + "\nHP: " + str(player3.hp) + "/" + str(player3.max_hp)
	status_label_player4.text = player4.character_name + "\nHP: " + str(player4.hp) + "/" + str(player4.max_hp)

func _on_player_turn(character):
	print("Turno player: ", character.character_name)
	turn_status.text = "Turno player: " + character.character_name
	await player_turn(character)

func _on_enemy_turn(character):
	print("Turno enemy: ", character.character_name)
	turn_status.text = "Turno enemy: " + character.character_name
	#await next_turn_button.pressed
	await character.take_turn()
	action_menu.hide_menu()
	turn_manager.end_turn()

func get_target(target):
	current_target = target

func wait_target():
	while current_target == null:
		await get_tree().process_frame
	return

func player_turn(character):
	action_menu.show_menu()
	
	while (true):
		var action = await action_menu.action_selected
		match action:
			"attack":
				print(character.character_name + " attack")
				turn_status.text = ("Turno player: " + character.character_name + "\n" +
				character.character_name + " choose: attack")
				await wait_target()
				var dmg = await character.attack(current_target)
				turn_status.text = ("Turno player: " + character.character_name + "\n" +
				character.character_name + " ha fatto " + str(dmg) + " danni a: " + current_target.character_name)
				await get_tree().create_timer(1.0).timeout
				current_target= null
				turn_manager.end_turn()
				return
			"skills":
				print(character.character_name + " skills")
				turn_status.text = ("Turno player: " + character.character_name + "\n" +
				character.character_name + " choose: skills")
				await get_tree().create_timer(1.0).timeout
				turn_manager.end_turn()
				return
			"talk":
				print(character.character_name + " talk")
				turn_status.text = ("Turno player: " + character.character_name + "\n" +
				character.character_name + " choose: talk")
				await get_tree().create_timer(1.0).timeout
				turn_manager.end_turn()
				return
			"pass":
				print(character.character_name + " pass")
				turn_status.text = ("Turno player: " + character.character_name + "\n" +
				character.character_name + " choose: pass")
				action_menu.hide_menu()
				await get_tree().create_timer(1.0).timeout
				turn_manager.end_turn()
				return
