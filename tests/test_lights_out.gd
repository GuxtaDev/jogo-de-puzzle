extends Node


func test_lights_out_solution_and_room_03_setup() -> void:
	var room_scene: PackedScene = load("res://scenes/room_03.tscn") as PackedScene
	assert(room_scene != null, "room_03 scene should load")
	var room: Room = room_scene.instantiate() as Room
	add_child(room)
	await get_tree().process_frame
	var puzzle: LightsOut = room.get_node("Props/LightsOut") as LightsOut
	assert(puzzle != null, "room_03 should contain exactly one LightsOut puzzle")
	assert(room.get_node_or_null("Props/LightsOut2") == null, "there should not be a duplicate puzzle")
	assert(puzzle.position == Vector2(224, 120), "the puzzle should be centered in the room")
	assert(puzzle.lights == [true, true, true, false, true, false, false, false, false], "initial arrangement should match the answer key")
	puzzle._player_in_range = true
	for index: int in [0, 1, 2, 4, 6, 8]:
		puzzle._on_cell_pressed(index)
	assert(puzzle.lights == [true, true, true, true, true, true, true, true, true], "the solution should turn every lamp on")
	var title: Label = room.get_node("HUD/PanelLayer/ReaderCenter/ReaderPanel/VBox/Title") as Label
	var body: Label = room.get_node("HUD/PanelLayer/ReaderCenter/ReaderPanel/VBox/Body") as Label
	assert(title.text == "SENHA", "solving should show the password textbox title")
	assert(body.text.contains("naner"), "the textbox should reveal the password")
	assert(room.get_node("Props/LightsOut") != null, "the puzzle instance should remain singular")
