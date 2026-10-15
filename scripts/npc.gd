
extends Node2D

var player_near: bool = false

@onready var interactive_area: Area2D = $InteractiveArea
@onready var dialogue_ui = get_tree().get_first_node_in_group("dialogue_ui")
@export var character_name: String = "Han Solo"
@export var dialogues: Array[String] = ["Welcome Sir"]
func _ready() -> void:
	interactive_area.body_entered.connect(_on_body_entered)
	interactive_area.body_exited.connect(_on_body_exited)

func _process(_delta: float) -> void:
	if player_near and Input.is_action_just_pressed("interact"):
		var dialogue_ui = get_tree().get_first_node_in_group("dialogue_ui")
		if dialogue_ui and not dialogue_ui.is_open:
			dialogue_ui.show_dialogue(character_name, dialogues)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_near = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_near = false
