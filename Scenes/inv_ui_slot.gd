extends Panel

@onready var item_visual: Sprite2D = $CenterContainer/Panel/item_display
@onready var amount: Label = $CenterContainer/Panel/Label
@onready var popup: Label = $CenterContainer/Panel/Label2
@export var inv: Inv

var item_slot : InvSlot = null
var test : InvSlot = null

func _ready():
	popup.visible = false

func update(slot: InvSlot):
	item_slot = slot
	if !slot.item:
		item_visual.visible = false
		amount.visible = false
	else:
		item_visual.visible = true
		item_visual.texture = slot.item.texture
		if slot.amount > 1:
			amount.visible = true
		amount.text = str(slot.amount)

func is_mouse_over(panel) -> bool:
	var mouse_position = get_viewport().get_mouse_position()
	var panel_rect = panel.get_global_rect()
	return panel_rect.has_point(mouse_position)

func right_click():
	pass

func double_click():
	if item_slot.item == null:
		return
	elif item_slot.item.usable:
		inv.insert(item_slot.item, 1, "-")
	else:
		return
	
func _on_button_mouse_entered():
	popup.visible = true
	if item_slot.item == null:
		popup.text = ""
	else:
		popup.text = str(item_slot.item.name)


func _on_button_mouse_exited():
	popup.visible = false

func use_item():
	pass	
