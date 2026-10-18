extends Node


func test_lights_out_input_requires_player_nearby() -> void:
	var room_scene: PackedScene = load("res://scenes/room_03.tscn") as PackedScene
	var room: Room = room_scene.instantiate() as Room
	add_child(room)
	await get_tree().process_frame
	for index: int in 4:
		await get_tree().physics_frame
	var puzzle: LightsOut = room.get_node("Props/LightsOut") as LightsOut
	var player: Player = room.get_node("Player") as Player
	assert(puzzle.global_position.distance_to(player.global_position) <= 150.0, "player should spawn beside the puzzle")
	puzzle._physics_process(0.016)
	assert(puzzle._player_in_range, "buttons should be enabled when player stands beside the puzzle")
	var start: Array[bool] = puzzle.lights.duplicate()
	puzzle._on_cell_pressed(0)
	assert(puzzle.lights != start, "click handler should toggle a cell when the player is in range")
	puzzle._player_in_range = false
	var outside_state: Array[bool] = puzzle.lights.duplicate()
	puzzle._on_cell_pressed(1)
	assert(puzzle.lights == outside_state, "click handler should ignore input after player leaves")