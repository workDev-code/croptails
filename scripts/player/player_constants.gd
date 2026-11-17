class_name PlayerConstants
extends RefCounted

enum Facing {
	FRONT,
	BACK,
	LEFT,
	RIGHT,
}

enum State {
	IDLE,
	WALK,
	TOOL,
}


static func facing_to_name(facing: Facing) -> String:
	match facing:
		Facing.FRONT:
			return "front"
		Facing.BACK:
			return "back"
		Facing.LEFT:
			return "left"
		Facing.RIGHT:
			return "right"
		_:
			return "front"


static func state_to_key(state: State) -> String:
	match state:
		State.IDLE:
			return "idle"
		State.WALK:
			return "walk"
		State.TOOL:
			return "tool"
		_:
			return "idle"
