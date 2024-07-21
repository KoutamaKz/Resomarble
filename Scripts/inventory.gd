extends Resource

class_name Inv

signal update

@export var slots: Array[InvSlot]

func insert(item: Item, amount, inc = null):
	var itemslots = slots.filter(func(slot): return slot.item == item)
	if not itemslots.is_empty():
		if inc == null:
			itemslots[0].amount += amount
		else:
			itemslots[0].amount -= amount
	else:
		var emptyslots = slots.filter(func(slot): return slot.item == null)
		if !emptyslots.is_empty():
			emptyslots[0].item = item
			emptyslots[0].amount = amount
	update.emit()
