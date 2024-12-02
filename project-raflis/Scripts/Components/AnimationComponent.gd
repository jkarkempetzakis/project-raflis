class_name AnimationComponent
extends Node

@onready var sprite: AnimatedSprite2D = $"../AnimatedSprite2D"

var current_state: String = "IDLE"
var is_attacking: bool = false

# Define animation priorities (higher number = higher priority)
const ANIMATION_PRIORITIES = {
	"IDLE": 0,
	"RUN": 0,
	"JUMP": 1,
	"FALL": 1,
	"ATTACK1": 2,
	"ATTACK2": 2,
	"TAKE_HIT": 3
}

func _ready() -> void:
	# Connect to animation finished signal
	if not sprite.animation_finished.is_connected(_on_animation_finished):
		sprite.animation_finished.connect(_on_animation_finished)
	print("Animation finished signal connected")  # Debug print
	# Set default animation speed
	sprite.speed_scale = 1.0

func set_state(new_state: String) -> void:
	# Don't interrupt higher priority animations
	if is_attacking and ANIMATION_PRIORITIES[new_state] <= ANIMATION_PRIORITIES["ATTACK1"]:
		return
	
	current_state = new_state
	play_animation()

func play_animation() -> void:
	# Ensure sprite is not paused
	sprite.speed_scale = 1.0
	
	match current_state:
		"IDLE":
			sprite.play("idle_evil_wizard_2")
		"RUN":
			sprite.play("run")
		"JUMP":
			sprite.play("jump")
		"FALL":
			sprite.play("fall")
		"ATTACK1":
			is_attacking = true
			sprite.stop()  # Stop current animation
			sprite.frame = 0  # Reset to first frame
			sprite.play("attack1")
		"ATTACK2":
			is_attacking = true
			sprite.stop()  # Stop current animation
			sprite.frame = 0  # Reset to first frame
			sprite.play("attack2")
		"TAKE_HIT":
			sprite.play("take_hit")
	
	print("Playing animation: ", current_state)  # Debug print

func _on_animation_finished() -> void:
	print("Animation finished: ", current_state)  # Debug print
	# When attack animations finish, return to idle
	if current_state in ["ATTACK1", "ATTACK2"]:
		is_attacking = false
		current_state = "IDLE"
		play_animation()

func flip_sprite(flip: bool) -> void:
	sprite.flip_h = flip
