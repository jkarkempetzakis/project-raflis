# Evil Wizard Character Controller Documentation

## Table of Contents
1. [Overview](#overview)
2. [Project Setup](#project-setup)
3. [Project Structure](#project-structure)
4. [Godot-Specific Concepts](#godot-specific-concepts)
5. [Components](#components)
6. [Input System](#input-system)
7. [Animation System](#animation-system)
8. [Physics and Movement](#physics-and-movement)
9. [Best Practices Used](#best-practices-used)

## Overview
This project implements a 2D character controller for an "Evil Wizard" character using Godot 4.x. The implementation uses a component-based architecture for maintainability and scalability.

## Project Setup

### Required Godot Settings
1. **Project Settings → Input Map**
   - Add the following actions:
     ```
     w -> W key
     a -> A key
     s -> S key
     d -> D key
     jump -> Spacebar
     attack1 -> Left Mouse Button
     attack2 -> F key
     ```

2. **Autoload Configuration**
   - Go to Project → Project Settings → Autoload
   - Add "res://Scripts/Autoload/InputManager.gd" as "InputManager"
   - This makes InputManager globally accessible

3. **Physics Settings**
   - Default gravity: 980
   - Can be adjusted in Project Settings → Physics → 2D

### Initial Scene Setup
1. Create a new scene with Node2D as root
2. Save as "res://Scenes/Main.tscn"
3. Set as main scene in Project Settings → Application → Run

## Project Structure

### File Organization
```
Project/
├── Scenes/
│   ├── Main.tscn              # Main game scene
│   └── evil_wizard.tres       # Sprite frames resource
├── Scripts/
│   ├── Player.gd             # Main player controller
│   ├── Autoload/
│   │   └── InputManager.gd   # Input mapping management
│   └── Components/
│       ├── MovementComponent.gd
│       ├── AnimationComponent.gd
│       └── CombatComponent.gd
```

### Scene Hierarchy
```
World (Node2D)
├── Player (CharacterBody2D)
│   ├── AnimatedSprite2D
│   ├── CollisionShape2D
│   ├── MovementComponent
│   ├── AnimationComponent
│   └── CombatComponent
└── Ground (StaticBody2D)
    ├── CollisionShape2D
    └── ColorRect
```

## Godot-Specific Concepts

### 1. Autoload (Singleton)
```gdscript
# Scripts/Autoload/InputManager.gd
extends Node

func _ready() -> void:
    setup_input_mappings()

func setup_input_mappings() -> void:
    # WASD Movement
    if not InputMap.has_action("w"):
        InputMap.add_action("w")
        var w_event = InputEventKey.new()
        w_event.keycode = KEY_W
        InputMap.action_add_event("w", w_event)
    # ... similar for other keys
```
- Autoloaded scripts are loaded before any scene
- Available globally via their node name
- Perfect for managing game-wide systems

### 2. Custom Resources
```gdscript
# Scenes/evil_wizard.tres
# SpriteFrames resource containing all character animations
animations = [{
    "frames": [...],
    "loop": false,
    "name": &"attack1",
    "speed": 12.0
}, ...]
```
- Created via the AnimatedSprite2D inspector
- Stores animation data separately from scenes
- Reusable across multiple scenes

### 3. Node Communication
```gdscript
# Signals (Similar to events in other engines)
signal attack_started(attack_name: String)

# Node paths and references
@onready var sprite: AnimatedSprite2D = $"../AnimatedSprite2D"

# Groups (not used in this project but useful to know)
add_to_group("players")
get_tree().get_nodes_in_group("players")
```

### 4. Export Variables
```gdscript
@export var speed: float = 300.0
@export var jump_force: float = -400.0
```
- Makes variables editable in the editor
- Supports type hints
- Can have default values

### 5. Scene Instancing
```gdscript
# How to instance this character in other scenes
var player_scene = preload("res://Scenes/Main.tscn")
var player_instance = player_scene.instantiate()
add_child(player_instance)
```

## Components

### MovementComponent (Scripts/Components/MovementComponent.gd)
```gdscript
class_name MovementComponent
extends Node

@export var speed: float = 300.0
@export var jump_force: float = -400.0
@export var gravity: float = 980.0

func physics_update(delta: float) -> void:
    # Apply gravity
    if not player.is_on_floor():
        player.velocity.y += gravity * delta
```
Key Features:
- Horizontal movement with normalized vectors (MovementComponent.gd: get_input_direction())
- Gravity and jumping mechanics (MovementComponent.gd: physics_update())
- Ground detection (MovementComponent.gd: is_on_floor())
- Movement state management (MovementComponent.gd: physics_update())

### AnimationComponent (Scripts/Components/AnimationComponent.gd)
```gdscript
const ANIMATION_PRIORITIES = {
    "IDLE": 0,
    "RUN": 0,
    "JUMP": 1,
    "FALL": 1,
    "ATTACK1": 2,
    "ATTACK2": 2,
    "TAKE_HIT": 3
}
```
Features:
- Priority-based animation system (AnimationComponent.gd: ANIMATION_PRIORITIES)
- State machine for animations (AnimationComponent.gd: set_state())
- Animation interruption handling (AnimationComponent.gd: set_state())
- Automatic state transitions (AnimationComponent.gd: _on_animation_finished())

### CombatComponent
```gdscript
@export var attack_cooldown: float = 0.5
```
Features:
- Multiple attack types
- Attack cooldown system
- Combat state management
- Attack animation coordination

## Animation System

### Available Animations
1. idle_evil_wizard_2
   - Loop: true
   - Speed: 5.0
2. run
   - Loop: true
   - Speed: 5.0
3. jump/fall
   - Loop: false
   - Speed: 5.0
4. attack1/attack2
   - Loop: false
   - Speed: 12.0/10.0
5. take_hit
   - Loop: false
   - Speed: 5.0

### Animation State Management
```gdscript
func play_animation() -> void:
    match current_state:
        "IDLE":
            sprite.play("idle_evil_wizard_2")
        "ATTACK1":
            is_attacking = true
            sprite.stop()  # Stop current animation
            sprite.frame = 0  # Reset to first frame
            sprite.play("attack1")
```

## Physics and Movement

### Character Physics
- Uses CharacterBody2D for precise movement control
- Custom gravity implementation
- Collision detection with CollisionShape2D

### Movement Mechanics
```gdscript
func get_input_direction() -> Vector2:
    var direction = Vector2.ZERO
    # Horizontal movement
    if Input.is_action_pressed("ui_right") or Input.is_action_pressed("d"):
        direction.x += 1
    if Input.is_action_pressed("ui_left") or Input.is_action_pressed("a"):
        direction.x -= 1
    return direction
```

## Best Practices Used

### 1. Component-Based Architecture
- Separation of concerns
- Modular design
- Easy to extend and maintain

### 2. Signal-Based Communication
```gdscript
signal attack_started(attack_name: String)
signal attack_finished
```
- Loose coupling between components
- Event-driven architecture

### 3. Type Safety
```gdscript
@onready var sprite: AnimatedSprite2D = $"../AnimatedSprite2D"
```
- Explicit type declarations
- Better error catching
- Improved code readability

### 4. Export Variables
```gdscript
@export var speed: float = 300.0
```
- Runtime configuration
- Designer-friendly values
- Easy testing and tweaking

## Common Issues and Solutions

### 1. Animation Issues
- **Problem**: Animations not playing
- **Solution**: Check animation names in SpriteFrames resource

### 2. Movement Issues
- **Problem**: Character floating
- **Solution**: Verify gravity and floor detection

### 3. Combat Issues
- **Problem**: Attacks not registering
- **Solution**: Check input mapping and signal connections

## Future Improvements
1. Add double jump capability
2. Implement wall sliding
3. Add attack combinations
4. Include hit detection
5. Add character stats system

---

## Credits
Created with Godot 4.x
Character assets: Evil Wizard sprite sheet
Documentation version: 1.0
