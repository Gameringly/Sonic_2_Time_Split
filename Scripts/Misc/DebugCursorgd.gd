extends Node2D

var debugSpeed = 5
var entity_scenes = {}
var current_index = 51

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_all_entities("res://entities")
	update_cursor_preview()
		
func load_all_entities(folder_path: String):
	var dir = DirAccess.open(folder_path)
	if not dir:
		push_error("Cannot open folder: %s" % folder_path)
		return
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if file_name.begins_with("."):
			file_name = dir.get_next()
			continue
		
		var full_path = folder_path + "/" + file_name
		if dir.current_is_dir():
			# Recurse into subfolder
			load_all_entities(full_path)
		elif file_name.ends_with(".tscn"):
			var scene = load(full_path)
			if scene:
				var key = file_name.get_basename()
				# Ensure unique keys even from different folders
				var unique_key = folder_path.replace("res://", "").replace("/", "_") + "_" + key
				entity_scenes[unique_key] = scene
		file_name = dir.get_next()
	dir.list_dir_end()

func spawn_selected_object():
	if entity_scenes.keys().is_empty():
		return
	var scene_key = entity_scenes.keys()[current_index]
	var scene = entity_scenes[scene_key]
	var instance = scene.instantiate()
	get_parent().get_parent().add_child(instance)
	instance.global_position = global_position
	instance.scale.x = get_parent().direction
	print("Spawned: ", scene_key)

func update_cursor_preview():
	if entity_scenes.keys().is_empty():
		$Sprite2D.texture = load("res://Graphics/Items/Rings/Ring1.png")
		return
	
	var scene_key = entity_scenes.keys()[current_index]
	var scene = entity_scenes[scene_key]

	# Create a temporary instance to extract the texture
	var temp_instance = scene.instantiate()

	# Try to find a Sprite2D or AnimatedSprite2D
	var sprite = find_first_sprite(temp_instance)
	if sprite is Sprite2D:
		var preview = $Sprite2D
		preview.texture = sprite.texture
		preview.hframes = sprite.hframes
		preview.vframes = sprite.vframes
		preview.frame = sprite.frame
		preview.region_enabled = sprite.region_enabled
		preview.region_rect = sprite.region_rect
		preview.flip_h = sprite.flip_h
		preview.flip_v = sprite.flip_v
		preview.scale = sprite.scale
		preview.offset = sprite.offset
	else:
		var anim_sprite = find_first_sprite(temp_instance)
		if anim_sprite:
			var frameIndex = anim_sprite.get_frame()
			var animationName = anim_sprite.animation
			var spriteFrames = anim_sprite.get_sprite_frames()
			var currentTexture = spriteFrames.get_frame_texture(animationName, frameIndex)
			$Sprite2D.texture = currentTexture
		else:
			$Sprite2D.texture = load("res://Graphics/Items/Rings/Ring1.png") # fallback
	temp_instance.queue_free()

func find_first_sprite(node):
	for child in node.get_children():
		if child is Sprite2D:
			return child
		elif child is AnimatedSprite2D:
			return child
		elif child.get_child_count() > 0:
			var found = find_first_sprite(child)
			if found:
				return found
	return null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("gm_action") or Input.is_action_pressed("gm_action2") or Input.is_action_pressed("gm_action3"):
		debugSpeed = 15
	else:
		debugSpeed = 5
	
	if Input.is_action_pressed("gm_right"):
		position.x += debugSpeed
	elif Input.is_action_pressed("gm_left"):
		position.x -= debugSpeed
	if Input.is_action_pressed("gm_up"):
		position.y -= debugSpeed
	elif Input.is_action_pressed("gm_down"):
		position.y += debugSpeed
	
	
	if Input.is_action_just_pressed("debug_spawn"):
		spawn_selected_object()

	if Input.is_action_just_pressed("debug_next"):
		current_index = (current_index + 1) % entity_scenes.keys().size()
		print("Selected: ", entity_scenes.keys()[current_index])
		update_cursor_preview()

	if Input.is_action_just_pressed("debug_prev"):
		current_index = (current_index - 1 + entity_scenes.keys().size()) % entity_scenes.keys().size()
		print("Selected: ", entity_scenes.keys()[current_index])
		update_cursor_preview()
	
	
