extends CharacterBody2D

@onready var movement_component: MovementComponent = $MovementComponent
@onready var animation_component: AnimationComponent = $AnimationComponent

func _physics_process(delta: float) -> void:
	movement_component.physics_update(delta)
