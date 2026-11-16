@tool
extends EditorScript

const PLAYER_SHEET_PATH := "res://assets/game/characters/basic_charakter_actions.png"
const TILLING_SHEET_PATH := "res://assets/game/characters/tilling.png"
const PLAYER_SCENE_PATH := "res://assets/scenes/charecters/player/player.tscn"
const FRAME_SIZE := Vector2i(32, 32)
const DIRECTION_ROWS := ["front", "back", "left", "right"]

func _run() -> void:
	print("[PlayerFrames] Bắt đầu tạo SpriteFrames cho player...")

	var sprite_frames := _build_player_sprite_frames()
	_remove_default_animation(sprite_frames)
	_add_tilling_animations(sprite_frames)
	_save_player_scene(sprite_frames)

	print("[PlayerFrames] Hoàn tất: đã cập nhật %s" % PLAYER_SCENE_PATH)
	print("[PlayerFrames] Animations hiện có: %s" % _animation_names(sprite_frames))


func _build_player_sprite_frames() -> SpriteFrames:
	var texture := _load_texture_or_error(PLAYER_SHEET_PATH)
	if texture == null:
		return SpriteFrames.new()

	var sprite_frames := SpriteFrames.new()
	var row_count := int(texture.get_height() / FRAME_SIZE.y)

	for row_index in range(min(DIRECTION_ROWS.size(), row_count)):
		var direction: String = DIRECTION_ROWS[row_index]
		for animation_kind in ["idle", "walk"]:
			var animation_name := "%s_%s" % [direction, animation_kind]
			if sprite_frames.has_animation(animation_name):
				sprite_frames.remove_animation(animation_name)

			sprite_frames.add_animation(animation_name)
			sprite_frames.set_animation_loop(animation_name, true)
			sprite_frames.set_animation_speed(animation_name, 5.0 if animation_kind == "idle" else 6.0)

			var start_col := 0 if animation_kind == "idle" else 2
			for frame_index in range(2):
				var atlas := AtlasTexture.new()
				atlas.atlas = texture
				atlas.region = Rect2((start_col + frame_index) * FRAME_SIZE.x, row_index * FRAME_SIZE.y, FRAME_SIZE.x, FRAME_SIZE.y)
				sprite_frames.set_frame(animation_name, frame_index, atlas)

	return sprite_frames


func _add_tilling_animations(sprite_frames: SpriteFrames) -> void:
	if not FileAccess.file_exists(TILLING_SHEET_PATH):
		print("[PlayerFrames] Warning: %s không tồn tại, bỏ qua animation tilling." % TILLING_SHEET_PATH)
		return

	var texture := load(TILLING_SHEET_PATH) as Texture2D
	if texture == null:
		push_error("[PlayerFrames] Không load được %s" % TILLING_SHEET_PATH)
		return

	var row_count := int(texture.get_height() / FRAME_SIZE.y)
	for row_index in range(min(DIRECTION_ROWS.size(), row_count)):
		var direction: String = DIRECTION_ROWS[row_index]
		var animation_name := "tilling_%s" % direction
		if sprite_frames.has_animation(animation_name):
			sprite_frames.remove_animation(animation_name)

		sprite_frames.add_animation(animation_name)
		sprite_frames.set_animation_loop(animation_name, false)
		sprite_frames.set_animation_speed(animation_name, 7.0)

		for frame_index in range(2):
			var atlas := AtlasTexture.new()
			atlas.atlas = texture
			atlas.region = Rect2(frame_index * FRAME_SIZE.x, row_index * FRAME_SIZE.y, FRAME_SIZE.x, FRAME_SIZE.y)
			sprite_frames.set_frame(animation_name, frame_index, atlas)

	print("[PlayerFrames] Đã thêm animation tilling từ %s" % TILLING_SHEET_PATH)


func _remove_default_animation(sprite_frames: SpriteFrames) -> void:
	if sprite_frames.has_animation("default"):
		sprite_frames.remove_animation("default")
		print("[PlayerFrames] Đã xoá animation 'default'.")


func _save_player_scene(sprite_frames: SpriteFrames) -> void:
	var root: Node
	if FileAccess.file_exists(PLAYER_SCENE_PATH):
		var scene_resource := ResourceLoader.load(PLAYER_SCENE_PATH, "PackedScene")
		if scene_resource is PackedScene:
			root = scene_resource.instantiate()
		else:
			root = CharacterBody2D.new()
			root.name = "Player"
	else:
		root = CharacterBody2D.new()
		root.name = "Player"

	if root == null:
		root = CharacterBody2D.new()
		root.name = "Player"

	if root.name == "":
		root.name = "Player"

	var animated_sprite: AnimatedSprite2D
	if root.has_node("AnimatedSprite2D"):
		animated_sprite = root.get_node("AnimatedSprite2D") as AnimatedSprite2D
	else:
		animated_sprite = AnimatedSprite2D.new()
		animated_sprite.name = "AnimatedSprite2D"
		root.add_child(animated_sprite)
		animated_sprite.owner = root

	animated_sprite.sprite_frames = sprite_frames
	animated_sprite.animation = "front_idle"
	animated_sprite.autoplay = "front_idle"
	if not animated_sprite.is_playing():
		animated_sprite.play("front_idle")

	var packed_scene := PackedScene.new()
	var pack_error := packed_scene.pack(root)
	if pack_error != OK:
		push_error("[PlayerFrames] Không thể đóng gói scene: %s" % error_string(pack_error))
		return

	var save_error := ResourceSaver.save(packed_scene, PLAYER_SCENE_PATH)
	if save_error != OK:
		push_error("[PlayerFrames] Không thể lưu scene: %s" % error_string(save_error))
		return

	print("[PlayerFrames] Đã lưu bảng animation vào %s" % PLAYER_SCENE_PATH)


func _load_texture_or_error(path: String) -> Texture2D:
	var texture := load(path) as Texture2D
	if texture == null:
		push_error("[PlayerFrames] Không tìm thấy sheet: %s" % path)
		return null
	return texture


func _animation_names(sprite_frames: SpriteFrames) -> Array:
	var names := []
	for animation_name in sprite_frames.get_animation_names():
		names.append(animation_name)
	return names
