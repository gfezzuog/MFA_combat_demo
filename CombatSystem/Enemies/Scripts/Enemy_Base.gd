extends Node
class_name enemy_base

@onready var hp : int
@onready var atk : int
@onready var def : int
@onready var wtr : int
@onready var fir : int
@onready var ert : int
@onready var win : int
@onready var prf : int
@onready var hly : int
@onready var spd : int

@onready var elem : int
@onready var sts : Array = []
enum STATUS {STEAM = 3, INCINERATION = 5, FLOOD = 6, FIRESTORM = 9, FREEZE = 10, SANDSTORM = 12, APOCRYPHAL = 48}
enum ELEMENTS {FIRE = 1, WATER = 2, EARTH = 4, WIND = 8, PROFANE = 16, HOLY = 32}

@onready var sprite := $DS_torso

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(_delta):
	if Input.is_action_pressed("placeholder1"):
		activate_highlight()
	if Input.is_action_pressed("placeholder2"):
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
	tween.tween_property(sprite.material, "shader_parameter/highlight_strength", 1.0, 0.15)

func deactivate_highlight():
	var tween = create_tween()
	tween.tween_property(sprite.material, "shader_parameter/highlight_strength", 0.0, 0.15)
