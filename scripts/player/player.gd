class_name Player
extends CharacterBody2D

const MOVE_SPEED: float = 90.0
const DEBUG_MOVEMENT: bool = false

var facing: PlayerConstants.Facing = PlayerConstants.Facing.FRONT
var current_state: String = "Idle"
var selected_tool: PlayerConstants.Tool = PlayerConstants.Tool.TILLING
var last_movement_key: String = "NONE"


func get_movement_input() -> Vector2:
	var input_vector := Vector2(
		Input.get_action_strength("walk_right") - Input.get_action_strength("walk_left"),
		Input.get_action_strength("walk_down") - Input.get_action_strength("walk_up")
	)

	var movement_key := "NONE"
	if input_vector != Vector2.ZERO:
		update_facing_from_vector(input_vector)
		if abs(input_vector.x) > abs(input_vector.y):
			movement_key = "RIGHT" if input_vector.x > 0 else "LEFT"
		elif input_vector.y != 0:
			movement_key = "DOWN" if input_vector.y > 0 else "UP"

	if movement_key != last_movement_key:
		last_movement_key = movement_key
		if DEBUG_MOVEMENT:
			print("[INPUT] Movement: %s" % movement_key)

	return input_vector


func update_facing_from_vector(direction: Vector2) -> void:
	if abs(direction.x) > abs(direction.y):
		facing = PlayerConstants.Facing.RIGHT if direction.x > 0 else PlayerConstants.Facing.LEFT
		return

	if direction.y != 0:
		facing = PlayerConstants.Facing.FRONT if direction.y > 0 else PlayerConstants.Facing.BACK


func direction_name() -> String:
	return PlayerConstants.facing_to_name(facing)


func get_animation_name(prefix: String) -> String:
	return "%s_%s" % [prefix, direction_name()]


func set_animation(animation_name: String) -> void:
	var sprite: AnimatedSprite2D = get_node_or_null("AnimatedSprite2D") as AnimatedSprite2D
	if sprite == null:
		return

	if sprite.animation != animation_name:
		sprite.play(animation_name)


func get_selected_tool_key() -> String:
	return PlayerConstants.tool_to_key(selected_tool)


func get_selected_tool_label() -> String:
	return PlayerConstants.tool_to_label(selected_tool)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("select_chopping"):
		selected_tool = PlayerConstants.Tool.CHOPPING
		print("[TOOL] Selected: %s" % get_selected_tool_label())
		return

	if event.is_action_pressed("select_tilling"):
		selected_tool = PlayerConstants.Tool.TILLING
		print("[TOOL] Selected: %s" % get_selected_tool_label())
		return

	if event.is_action_pressed("select_watering"):
		selected_tool = PlayerConstants.Tool.WATERING
		print("[TOOL] Selected: %s" % get_selected_tool_label())
		return

	if event.is_action_pressed("use_tool"):
		print("[TOOL] Use requested: %s" % get_selected_tool_label())
		var state_machine := get_node_or_null("StateMachine") as NodeStateMachine
		if state_machine != null:
			if state_machine.current_state != null:
				if String(state_machine.current_state.name).to_lower() == "tool":
					return
			state_machine.change_state(PlayerConstants.State.TOOL)
		return

	if event.is_action_pressed("interact"):
		try_interact()


func try_interact() -> void:
	for node in get_tree().get_nodes_in_group("interactable"):
		var interactable := node as Interactable
		if interactable != null and interactable.overlaps_body(self):
			interactable.interact(self)
			return
	print("[INPUT] Interaction requested: no target")


func _ready() -> void:
	add_to_group("player")
	print("[PLAYER] Ready: %s" % name)
