extends Node


func test_ending_scene_and_last_door() -> void:
	var ending_scene: PackedScene = load("res://scenes/ending.tscn") as PackedScene
	assert(ending_scene != null, "ending scene should load")
	var ending: Node = ending_scene.instantiate()
	assert(ending.get_node_or_null("Interface/Center/Panel/VBox/Message") != null, "ending should have a message box")
	assert(ending.get_node_or_null("Plates/NameLeft") != null, "ending should show the left credit")
	assert(ending.get_node_or_null("Plates/NameRight") != null, "ending should show the right credit")
	ending.free()

	var room_scene: PackedScene = load("res://scenes/room_03.tscn") as PackedScene
	var room: Room = room_scene.instantiate() as Room
	add_child(room)
	await get_tree().process_frame
	var door: Door = room.get_node("Props/Door") as Door
	assert(door.destination.ends_with("ending.tscn"), "the last door should lead to the ending screen")
	room._on_password_attempted(door, door.password)
	assert(door.is_open, "the last door's password should open it")
	assert(room._exit_open, "the exit should open once the last door is unlocked")
