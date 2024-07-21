extends Node

@export var _20: Array = [Item]
@export var _50: Array = [Item]
@onready var sprite = $Sprite2D

func _ready():
	self.visible = false

func drop_control():
	var chance = randi_range(0, 100)
	if chance < 20:
		self.visible = true
		print("20")
		var item: Item = _20.pick_random()
		sprite.texture = item.texture
	elif chance < 50:
		self.visible = true
		print("50")
		var item: Item = _50.pick_random()
		sprite.texture = item.texture

func _on_pick_up_area_body_entered(body):
	print("pegou")
