extends Node
class_name enemy_base

# =========================
# STATS
# =========================
@export var character_name: String
@export var hp : int
@export var atk : int
@export var def : int
@export var wtr : int
@export var fir : int
@export var ert : int
@export var win : int
@export var prf : int
@export var hly : int
@export var spd : int

# =========================
# ELEMENT / STATUS SYSTEM
# =========================
@onready var elem : int = 0
@onready var sts : Array = []

enum STATUS {
	STEAM = 3,
	INCINERATION = 5,
	FLOOD = 6,
	FIRESTORM = 9,
	FREEZE = 10,
	SANDSTORM = 12,
	APOCRYPHAL = 48
}

enum ELEMENTS {
	FIRE = 1,
	WATER = 2,
	EARTH = 4,
	WIND = 8,
	PROFANE = 16,
	HOLY = 32
}

# =========================
# ACTION SYSTEM
# =========================
var actions = []

# riferimento al sistema di combattimento (INJECTED)
var turn_manager = null

# =========================
# VISUAL
# =========================
@onready var sprite = $Sprite2D


# =========================
# SETUP
# =========================

func set_turn_manager(tm):
	turn_manager = tm


# =========================
# BASE METHODS
# =========================

func is_alive() -> bool:
	return hp > 0


# =========================
# TURN LOGIC
# =========================

func take_turn():
	var action = choose_action()
	print(action)
	if action == null:
		end_my_turn()
		return
	var target = choose_target()
	execute_action(action, target)
	end_my_turn()


func choose_action():
	if actions.is_empty():
		return null
	print(actions)
	return actions.pick_random()


func choose_target():
	if turn_manager == null:
		return null
	var alive_party = turn_manager.party.filter(func(p): return p.is_alive())
	if alive_party.is_empty():
		return null
	
	return alive_party.pick_random()


func execute_action(action, target):
	if target == null:
		return
	
	match action.type:
		"attack":
			var multiplier = action.get("multiplier", 1.0)
			var damage = max(1, int((atk * multiplier) - target.def))
			#target.get_damaged(damage)
			print(character_name, " usa ", action.name, " su ", target.character_name, " per ", damage)
		#
		#"heal":
			#hp += action.value
			#print(character_name, " si cura di ", action.value)


func end_my_turn():
	if turn_manager != null:
		turn_manager.end_turn()


# =========================
# DAMAGE SYSTEM
# =========================

func get_damaged(damage):
	hp -= damage
	hp = max(hp, 0)


# =========================
# ELEMENT SYSTEM (TUO)
# =========================

func apply_element(new_element : ELEMENTS) -> void:
	if (elem & new_element == 0):
		elem += new_element
	apply_status()


func split_powers(S):
	var powers : Array = []
	var bit = 0
	while S:
		if S & 1:
			powers.append(2**bit)
		S >>= 1
		bit += 1
	return powers


func cleanse_element(c_element : ELEMENTS) -> void:
	if (elem & c_element != 0):
		elem -= c_element


func apply_status() -> void:
	for s in STATUS.values():
		if (s & elem == s):
			sts.append(s)
			var powers = split_powers(s)
			for j in powers:
				cleanse_element(j)


# =========================
# VISUAL
# =========================

func activate_highlight():
	var tween = create_tween()
	tween.tween_property(sprite.material, "shader_parameter/highlight_strength", 1.0, 0.15)


func deactivate_highlight():
	var tween = create_tween()
	tween.tween_property(sprite.material, "shader_parameter/highlight_strength", 0.0, 0.15)
