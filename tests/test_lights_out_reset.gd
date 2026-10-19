extends Node


func test_closing_puzzle_panel_resets_it() -> void:
	var room: Room = (load("res://scenes/room_03.tscn") as PackedScene).instantiate() as Room
	add_child(room)
	await get_tree().process_frame
	var puzzle: LightsOut = room.get_node("Props/LightsOut") as LightsOut
	var hud: HUD = room.get_node("HUD") as HUD
	var start: Array[bool] = puzzle.start_lights.duplicate()
	room._on_interacted(puzzle)
	assert(hud.is_panel_open(), "interacting should open the puzzle panel")
	puzzle.press(0)
	puzzle.press(4)
	assert(puzzle.lights != start, "pressing lamps should change the pattern")
	hud.close_panel()
	assert(puzzle.lights == start, "closing the panel should reset the console to its opening arrangement")
	assert(not puzzle.is_solved(), "the reset console should no longer count as solved")
	room.queue_free()