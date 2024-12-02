class_name MovementComponent
extends Node

@export var speed: float = 300.0
@export var jump_force: float = -400.0
@export var gravity: float = 980.0

var player: CharacterBody2D
@onready var animation_component: AnimationComponent = $"../AnimationComponent"

func _ready() -> void:
	print("MovementComponent _ready called")
	player = get_parent() as CharacterBody2D
	if player == null:
		push_error("MovementComponent: Failed to get player reference")
	else:
		print("MovementComponent: Successfully got player reference")

func physics_update(delta: float) -> void:
	if player == null:
		push_error("MovementComponent: Player reference is null")
		return
	
	# Apply gravity
	if not player.is_on_floor():
		player.velocity.y += gravity * delta
		if player.velocity.y > 0:
			animation_component.set_state("FALL")
		else:
			animation_component.set_state("JUMP")
	
	# Handle jump
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		player.velocity.y = jump_force
		animation_component.set_state("JUMP")
	
	# Handle horizontal movement
	var direction = get_input_direction()
	if direction.length() > 0:
		direction = direction.normalized()
		player.velocity.x = direction.x * speed
		if player.is_on_floor():  # Only play run animation when on floor
			animation_component.set_state("RUN")
		if direction.x != 0:
			animation_component.flip_sprite(direction.x < 0)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, speed)
		if player.is_on_floor():  # Only play idle animation when on floor
			animation_component.set_state("IDLE")
	
	player.move_and_slide()

func get_input_direction() -> Vector2:
	var direction = Vector2.ZERO
	# Horizontal movement
	if Input.is_action_pressed("ui_right") or Input.is_action_pressed("d"):
		direction.x += 1
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("a"):
		direction.x -= 1
	
	return direction 
