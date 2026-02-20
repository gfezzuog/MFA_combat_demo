extends Node2D


func _ready() -> void:
	$fire.pressed.connect(on_button_pressed.bind(enemy_base.ELEMENTS.FIRE))
	$water.pressed.connect(on_button_pressed.bind(enemy_base.ELEMENTS.WATER))
	$wind.pressed.connect(on_button_pressed.bind(enemy_base.ELEMENTS.WIND))
	$earth.pressed.connect(on_button_pressed.bind(enemy_base.ELEMENTS.EARTH))
	$holy.pressed.connect(on_button_pressed.bind(enemy_base.ELEMENTS.HOLY))
	$profane.pressed.connect(on_button_pressed.bind(enemy_base.ELEMENTS.PROFANE))
	
	pass # Replace with function body.

func on_button_pressed(element):
	$AngelicDinosaur.apply_element(element)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
