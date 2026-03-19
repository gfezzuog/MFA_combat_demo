extends Control

signal action_selected(action)

func _ready():
	hide()

func show_menu():
	show()

func hide_menu():
	hide()

func _on_actions_pressed() -> void:
	action_selected.emit("actions")

func _on_items_pressed() -> void:
	action_selected.emit("items")

func _on_talk_pressed() -> void:
	action_selected.emit("talk")

func _on_pass_pressed() -> void:
	action_selected.emit("pass")
