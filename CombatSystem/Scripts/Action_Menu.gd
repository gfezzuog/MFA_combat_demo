extends Control

signal action_selected(action)
@onready var button_container = $Target_selector/VBoxContainer/VBoxContainer
@onready var target_selector = $Target_selector

# target per ora statico direttamente su AngeliDinosaur, da rendere eventualmente dinamico
@onready var target : Node = get_parent().get_node("Enemies/AngelicDinosaur")
var target_node_array : Array[Node] = []
#var target_name_array : Array[String] = []



@onready var combat_node : Node = get_parent()

func _ready():
	target_selector.hide()
	hide()
	create_enemies_array()
	create_buttons()

func show_menu():
	show()

func hide_menu():
	hide()
func create_enemies_array():
	target_node_array.clear() 
	#target_name_array.clear()
	if target == null:
		return
	target_node_array = target.get_children()
	#for child in target.get_children():
		#var character_name = child.get("character_name")
		#if character_name != null:
			#target_node_array.append(child)
			#target_name_array.append(character_name)

func create_buttons():
	for child in button_container.get_children():
		child.queue_free()
	for i in target_node_array:
		var button = Button.new()
		button.text = i.character_name
		button_container.add_child(button)
		button.pressed.connect(Callable(self, "_on_enemy_button_pressed").bind(i.character_name))

func _on_enemy_button_pressed(enemy_name : String):
	for i in range(target_node_array.size()):
		if target_node_array[i].character_name == enemy_name:
			var enemy_node = target_node_array[i]
			combat_node.get_target(enemy_node)
	target_selector.hide()
	return

func _on_attack_pressed() -> void:
	target_selector.show()
	action_selected.emit("attack")

func _on_skills_pressed() -> void:
	action_selected.emit("skills")

func _on_talk_pressed() -> void:
	action_selected.emit("talk")

func _on_pass_pressed() -> void:
	action_selected.emit("pass")
