extends Node
class_name Character_Base

@export var character_name: String
@export var max_hp: int = 100
@export var hp: int
@export var atk : int
@export var matk : int
@export var def : int
@export var mdef : int
@export var spd: int

func _ready():
	hp = max_hp

func is_alive() -> bool:
	if hp > 0:
		return true
	return false
