extends CanvasLayer

@export_category("Objects")
@export var character: CharacterBody2D = null

@export var item: Item
@export var items: InvSlot
var path = "res://Resources/save/playerinv.tres"
@export var inv: Inv

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_inv_button_button_up():
	pass


func _on_inv_button_button_down():
	inv.insert(item, 1)
	ResourceSaver.save(inv, path)
