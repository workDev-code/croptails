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

enum Tool {
	CHOPPING,
	TILLING,
	WATERING,
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


static func tool_to_key(tool: Tool) -> String:
	match tool:
		Tool.CHOPPING:
			return "chopping"
		Tool.TILLING:
			return "tilling"
		Tool.WATERING:
			return "watering"
		_:
			return "tilling"


static func tool_to_label(tool: Tool) -> String:
	match tool:
		Tool.CHOPPING:
			return "CHOPPING"
		Tool.TILLING:
			return "TILLING"
		Tool.WATERING:
			return "WATERING"
		_:
			return "TILLING"
