extends Node2D

var player_nearby: bool = false

@onready var interactive_area: Area2D = $InteractiveArea
@onready var dialogue_ui = get_tree().get_first_node_in_group("dialogue_ui")
@export var character_name: String = "Han Solo"
@export var dialogues: Array[String] = ["Welcome Sir"]
func _ready() -> void:
	interactive_area.body_entered.connect(
		_on_interactive_area_body_entered
		)
	interactive_area.body_exited.connect(
		_on_interactive_area_body_exited
		)
		
func _process(_delta: float) -> void:
	if player_nearby and Input.is_action_just_pressed("interact"):
		interact()
		
func interact() -> void:
	var dialogue_ui = get_tree().current_scene.get_node("DialogueUI")
	if dialogue_ui.is_open:
		return
	match QuestManager.quest_state:
		QuestManager.QuestState.NOT_STARTED:
			var mensajes: Array[String] = [
					"Guard!, i need your help", 
					"The enemy has scattered the three magic crystals around the city",
					"Get them back quickly and bring them to us before they get lost."
			]
			dialogue_ui.show_dialogue(
				"Han Solo",
				mensajes
			)
			QuestManager.start_quest()
		QuestManager.QuestState.ACTIVE:
			var mensajes: Array[String] = [
				"You are still missing crystals.",
				"You only find %d de %d" % [
					QuestManager.collected_crystals,
					QuestManager.required_crystals
					]
				]
			dialogue_ui.show_dialogue(
				"Han Solo",
				mensajes
			)
		QuestManager.QuestState.READY_TO_DELIVER:
			var mensajes: Array[String] = [
					"Perfect!, thank you so much for helping me ",
					"You recovered all the crystals in time.",
					"Now we can active the portal."
				]
			dialogue_ui.show_dialogue(
				"Han Solo",
				mensajes
			)
			QuestManager.complete_quest()
		QuestManager.QuestState.COMPLETED:
			var mensajes: Array[String] = [
					"Thanks for your help!",
					"The portal is ready to use.",
					"Have a goood trip!"
				]
			dialogue_ui.show_dialogue(
				"Han Solo",
				mensajes
			)
func _on_interactive_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_nearby = true
	pass # Replace with function body.


func _on_interactive_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_nearby = false
		pass # Replace with function body.
