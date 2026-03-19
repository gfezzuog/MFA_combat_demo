extends Control

signal action_selected(action)
@onready var button_container = $Target_selector/VBoxContainer/VBoxContainer
@onready var target_selector = $Target_selector

# target per ora statico direttamente su AngeliDinosaur, da rendere eventualmente dinamico
@onready var target : Node = get_parent().get_node("Enemies/AngelicDinosaur")
var target_array : Array[String] = []

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
	if target == null:
		return
	for child in target.get_children():
		var character_name = child.get("character_name")
		if character_name != null:
			target_array.append(character_name)

func create_buttons():
	for child in button_container.get_children():
		child.queue_free()
	for character_name in target_array:
		var button = Button.new()
		button.text = character_name
		button_container.add_child(button)
		button.pressed.connect(Callable(self, "_on_enemy_button_pressed").bind(character_name))

func _on_enemy_button_pressed(enemy_name : String):
	print("Hai cliccato il nemico:", enemy_name)

func _on_attack_pressed() -> void:
	target_selector.show()
	action_selected.emit("attack")

func _on_skills_pressed() -> void:
	action_selected.emit("skills")

func _on_talk_pressed() -> void:
	action_selected.emit("talk")

func _on_pass_pressed() -> void:
	action_selected.emit("pass")
