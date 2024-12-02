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
    
    if not InputMap.has_action("a"):
        InputMap.add_action("a")
        var a_event = InputEventKey.new()
        a_event.keycode = KEY_A
        InputMap.action_add_event("a", a_event)
    
    if not InputMap.has_action("s"):
        InputMap.add_action("s")
        var s_event = InputEventKey.new()
        s_event.keycode = KEY_S
        InputMap.action_add_event("s", s_event)
    
    if not InputMap.has_action("d"):
        InputMap.add_action("d")
        var d_event = InputEventKey.new()
        d_event.keycode = KEY_D
        InputMap.action_add_event("d", d_event)
    
    # Jump
    if not InputMap.has_action("jump"):
        InputMap.add_action("jump")
        var space_event = InputEventKey.new()
        space_event.keycode = KEY_SPACE
        InputMap.action_add_event("jump", space_event)
    
    # Attack 1 (Left Click)
    if not InputMap.has_action("attack1"):
        InputMap.add_action("attack1")
        var click_event = InputEventMouseButton.new()
        click_event.button_index = MOUSE_BUTTON_LEFT
        InputMap.action_add_event("attack1", click_event)
    
    # Attack 2 (F key)
    if not InputMap.has_action("attack2"):
        InputMap.add_action("attack2")
        var f_event = InputEventKey.new()
        f_event.keycode = KEY_F
        InputMap.action_add_event("attack2", f_event)