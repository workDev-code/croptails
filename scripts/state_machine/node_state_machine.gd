class_name NodeStateMachine
extends Node


"""`
Đây là bộ quản lý trạng thái.

Nhiệm vụ:
- Tìm các State là node con.
- Lưu danh sách State.
- Xác định State ban đầu.
- Quản lý State hiện tại.
- Chuyển đổi State.
- Gọi các hàm lifecycle tương ứng.
"""`


@export var initial_state: String = "idle"

var actor: Player
var current_state: NodeState
var states: Dictionary = {}


func _ready() -> void:
	call_deferred("_initialize")


func initialize(new_actor: Player) -> void:
	actor = new_actor
	_initialize()


func _initialize() -> void:
	if actor == null:
		actor = get_parent() as Player
	if actor == null:
		return

	states.clear()
	for child in get_children():
		if child is NodeState:
			child.state_machine = self
			child.actor = actor
			states[String(child.name).to_lower()] = child

	if current_state == null and states.has(initial_state.to_lower()):
		change_state(initial_state)


func _process(delta: float) -> void:
	if current_state != null:
		current_state.update(delta)


func _physics_process(delta: float) -> void:
	physics_update(delta)


func physics_update(delta: float) -> void:
	if current_state != null:
		current_state.physics_update(delta)


func handle_input(event: InputEvent) -> void:
	if current_state != null:
		current_state.handle_input(event)


func _unhandled_input(event: InputEvent) -> void:
	handle_input(event)


func change_state(state_name: String) -> void:
	var name_key := String(state_name).to_lower()
	if not states.has(name_key):
		push_warning("State not found: %s" % state_name)
		return

	if current_state != null:
		current_state.exit()

	current_state = states[name_key]
	actor.current_state = name_key
	current_state.enter()


func on_animation_finished() -> void:
	if current_state != null:
		current_state.on_animation_finished()
