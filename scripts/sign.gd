class_name Sign
extends Interactable

@export var title: String = "Sign"
@export_multiline var body: String = ""


func _ready() -> void:
	super()
	if prompt == "Interact":
		prompt = "Ler"


func read() -> Dictionary:
	return {"title": title, "body": body}
