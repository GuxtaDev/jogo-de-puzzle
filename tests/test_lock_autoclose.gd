extends Node


func test_correct_password_closes_lock_panel_by_itself() -> void:
	var room: Room = (load("res://scenes/room_03.tscn") as PackedScene).instantiate() as Room
	add_child(room)
	await get_tree().process_frame
	var door: Door = room.get_node("Props/Door") as Door
	var hud: HUD = room.get_node("HUD") as HUD
	room._on_interacted(door)
	assert(hud.is_panel_open(), "interacting with a sealed door opens the lock panel")
	room._on_password_attempted(door, door.password)
	assert(door.is_open, "the correct password unlocks the door")
	assert(hud.is_panel_open(), "the panel lingers for a moment to show the seal breaking")
	await get_tree().create_timer(Room.LOCK_AUTO_CLOSE_DELAY + 0.25).timeout
	assert(not hud.is_panel_open(), "the lock panel should close itself after a correct password")
	room.queue_free()


func test_wrong_password_keeps_lock_panel_open() -> void:
	var room: Room = (load("res://scenes/room_03.tscn") as PackedScene).instantiate() as Room
	add_child(room)
	await get_tree().process_frame
	var door: Door = room.get_node("Props/Door") as Door
	var hud: HUD = room.get_node("HUD") as HUD
	room._on_interacted(door)
	room._on_password_attempted(door, "palavra errada")
	assert(not door.is_open, "a wrong password should not unlock the door")
	await get_tree().create_timer(Room.LOCK_AUTO_CLOSE_DELAY + 0.25).timeout
	assert(hud.is_panel_open(), "a wrong password should leave the panel open for another try")
	room.queue_free()