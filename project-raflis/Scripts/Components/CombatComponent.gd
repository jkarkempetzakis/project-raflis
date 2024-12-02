class_name CombatComponent
extends Node

signal attack_started(attack_name: String)
signal attack_finished

@onready var animation_component: AnimationComponent = $"../AnimationComponent"

var can_attack: bool = true
@export var attack_cooldown: float = 0.5  # Seconds between attacks

func _unhandled_input(event: InputEvent) -> void:
	if not can_attack:
		return
	
	if event.is_action_pressed("attack1"):
		perform_attack("attack1")
	elif event.is_action_pressed("attack2"):
		perform_attack("attack2")

func perform_attack(attack_name: String) -> void:
	attack_started.emit(attack_name)
	animation_component.set_state(attack_name.to_upper())
	can_attack = false
	
	# Start cooldown timer
	get_tree().create_timer(attack_cooldown).timeout.connect(
		func(): can_attack = true
	)
