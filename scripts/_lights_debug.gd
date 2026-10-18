extends Node2D

func _ready() -> void:
	var room: Node = load("res://scenes/room_03.tscn").instantiate()
	add_child(room)
	await get_tree().process_frame
	var puzzle: LightsOut = room.get_node("Props/LightsOut") as LightsOut
	print("DEBUG: initial lights=", puzzle.lights, " mouse_filter=", puzzle.get_node("Grid").mouse_filter)
	var button: Button = puzzle.get_node("Grid/Cell0") as Button
	button.pressed.emit()
	print("DEBUG after one click=", puzzle.lights, " status=", puzzle.get_node("Status").text)
	for index in [1, 2, 4, 6, 8]:
		var cell: Button = puzzle.get_node("Grid/Cell%d" % index) as Button
		cell.pressed.emit()
	print("DEBUG after solution=", puzzle.lights, " solved=", puzzle.get("_is_solved"), " hud=", room.get_node("HUD/PanelLayer/ReaderCenter/ReaderPanel/VBox/Title").text)
	get_tree().quit()
