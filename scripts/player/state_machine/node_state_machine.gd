class_name NodeStateMachine
extends Node

"""
Controller that owns the active state for the player.

Responsibilities:
- find the parent player and its AnimatedSprite2D
- register child NodeState nodes by their names
- switch current state safely with exit/enter lifecycle
- forward physics and animation events to the active state
"""

@export var initial_state: PlayerConstants.State = PlayerConstants.State.IDLE

var actor: CharacterBody2D
var animated_sprite: AnimatedSprite2D
var current_state: NodeState
var states: Dictionary = {}


static func state_to_key(state: Variant) -> String:
	if state is PlayerConstants.State:
		return PlayerConstants.state_to_key(state)
	return String(state).to_lower()


func _ready() -> void:
	_initialize()


func _initialize() -> void:
	actor = get_parent() as CharacterBody2D
	if actor == null:
		push_error("NodeStateMachine must be a child of a CharacterBody2D.")
		return

	animated_sprite = actor.get_node_or_null("AnimatedSprite2D") as AnimatedSprite2D
	if animated_sprite != null and not animated_sprite.animation_finished.is_connected(_on_animation_finished):
		animated_sprite.animation_finished.connect(_on_animation_finished)

	states.clear()
	for child in get_children():
		if child is NodeState:
			child.setup(actor, self, animated_sprite)
			states[String(child.name).to_lower()] = child

	if current_state == null:
		var key := state_to_key(initial_state)
		if states.has(key):
			change_state(initial_state)
		else:
			push_warning("Initial state '%s' was not found in registered states." % initial_state)


func _physics_process(delta: float) -> void:
	if current_state == null:
		return
	current_state.physics_update(delta)


func change_state(state_name: Variant) -> void:
	if state_name == null:
		push_warning("NodeStateMachine: empty state name received.")
		return

	var key := state_to_key(state_name)
	if not states.has(key):
		push_warning("NodeStateMachine: state '%s' not found." % state_name)
		return

	if current_state != null:
		var current_key := String(current_state.name).to_upper()
		var next_key := key.to_upper()
		if current_key != next_key:
			print("[STATE] %s -> %s" % [current_key, next_key])
		current_state.exit()

	current_state = states[key]
	if current_state == null:
		push_error("NodeStateMachine: target state is null after lookup.")
		return

	if actor != null:
		actor.current_state = key.capitalize()
	current_state.enter()


func _on_animation_finished() -> void:
	if current_state == null:
		return
	current_state.on_animation_finished()
