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

func is_alive() -> bool:
	if hp > 0:
		return true
	return false

func attack(target: enemy_base):
	var damaged = target.hp - atk
	target.get_damaged(damaged)
	print("il bro sta attaccando")
	return atk
