extends Node2D

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
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

@onready var turn_manager = $TurnManager

func _ready():
	var party_nodes = $Party.get_children()
	var enemy_nodes = $AngelicDinosaur.get_children()
	
	turn_manager.player_turn_started.connect(_on_player_turn)
	turn_manager.enemy_turn_started.connect(_on_enemy_turn)
	
	turn_manager.start_combat(party_nodes, enemy_nodes)

func _on_player_turn(character):
	print("Turno player:", character.character_name)
	await $fire.pressed
	turn_manager.end_turn()

func _on_enemy_turn(character):
	print("Turno enemy:", character.character_name)
	await $wind.pressed
	turn_manager.end_turn()
