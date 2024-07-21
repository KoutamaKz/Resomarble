extends Control

@onready var inv: Inv = preload("res://Resources/save/playerinv.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
@export var stat: PlayerStats
@onready var infol: Array = $NinePatchRect/InfoLabels.get_children()

var is_open = false

func _ready():
	inv.update.connect(update_slots)
	update_slots()
	close()

func update_slots():
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].update(inv.slots[i])

func _process(delta):
	update_stats()
	if Input.is_action_just_pressed("inventory"):
		if is_open:
			close()
		else:
			open()
	
func open():
	self.visible = true
	is_open = true

func close():
	self.visible = false
	is_open = false

func update_stats():
	var maxlife = stat.maxlife
	var strength = stat.strength
	var energy = stat.energy
	for l in infol:
		var st = l.text
		if st.begins_with("Max Health:"):
			l.text = "Max Health: " + str(maxlife)
		elif st.begins_with("Strength:"):
			l.text = "Strength: " + str(strength)
		elif st.begins_with("Energy:"):
			l.text = "Energy: " + str(energy)
	
