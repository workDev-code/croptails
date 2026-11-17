extends CharacterBody2D
class_name Player

const MOVE_SPEED := 90.0

const FACING_FRONT := "front"
const FACING_BACK := "back"
const FACING_LEFT := "left"
const FACING_RIGHT := "right"

var facing: String = FACING_FRONT
var current_state: String = "idle"

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine: NodeStateMachine = $StateMachine


func _ready() -> void:
	if state_machine != null:
		if state_machine is NodeStateMachine:
			(state_machine as NodeStateMachine).initialize(self)
	animated_sprite.animation_finished.connect(_on_animation_finished)
	animated_sprite.play("idle_front")


func _unhandled_input(event: InputEvent) -> void:
	if state_machine != null and state_machine is NodeStateMachine:
		(state_machine as NodeStateMachine).handle_input(event)


func _physics_process(delta: float) -> void:
	if state_machine != null and state_machine is NodeStateMachine:
		(state_machine as NodeStateMachine).physics_update(delta)


func get_movement_input() -> Vector2:
	return Vector2(
		Input.get_action_strength("walk_right") - Input.get_action_strength("walk_left"),
		Input.get_action_strength("walk_down") - Input.get_action_strength("walk_up")
	)


func update_facing_from_vector(input_vector: Vector2) -> void:
	if absf(input_vector.x) > absf(input_vector.y):
		facing = FACING_RIGHT if input_vector.x > 0.0 else FACING_LEFT
		return

	if input_vector.y > 0.0:
		facing = FACING_FRONT
	elif input_vector.y < 0.0:
		facing = FACING_BACK


func set_animation(animation_name: String) -> void:
	if animated_sprite == null:
		return

	if animation_name != animated_sprite.animation:
		animated_sprite.play(animation_name)


func _on_animation_finished() -> void:
	if state_machine != null and state_machine is NodeStateMachine:
		(state_machine as NodeStateMachine).on_animation_finished()
