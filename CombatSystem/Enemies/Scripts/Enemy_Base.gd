extends Node
class_name enemy_base

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

@onready var elem : int
@onready var sts : Array = []
enum STATUS {STEAM = 3, INCINERATION = 5, FLOOD = 6, FIRESTORM = 9, FREEZE = 10, SANDSTORM = 12, APOCRYPHAL = 48}
enum ELEMENTS {FIRE = 1, WATER = 2, EARTH = 4, WIND = 8, PROFANE = 16, HOLY = 32}

func is_alive() -> bool:
	if hp > 0:
		return true
	return false

func _process(_delta):
	if Input.is_action_just_pressed("placeholder1"):
		activate_highlight()
	if Input.is_action_just_pressed("placeholder2"):
		deactivate_highlight()

func apply_element(new_element : ELEMENTS) -> void:
	if (elem & new_element == 0):
		elem += new_element
	print("L'elemento applicato è il numero ", elem)
	apply_status()
	
func split_powers(S):
	var powers : Array = []
	var bit = 0
	while S:
		if S & 1:
			powers.append(2**bit)   # a = 2^bit
		S >>= 1
		bit += 1
	return powers

func cleanse_element(c_element : ELEMENTS) -> void:
	if (elem & c_element != 0):
		elem -= c_element
	
func apply_status() -> void:
	for s in STATUS.values():
		if(s & elem == s):
			sts.append(s)
			var powers = split_powers(s)
			for j in powers:
				cleanse_element(j)
	for i in sts:
		print("Lo status applicato è il numero ", i)
	
	
	




## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

func activate_highlight():
	var tween = create_tween()
	tween.tween_property(self.material, "shader_parameter/highlight_strength", 1.0, 0.15)

func deactivate_highlight():
	var tween = create_tween()
	tween.tween_property(self.material, "shader_parameter/highlight_strength", 0.0, 0.15)
