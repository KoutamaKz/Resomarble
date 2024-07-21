extends Node

@onready var pathinv: String = "res://Resources/save/playerinv.tres"
@onready var pathstat: String = "res://Resources/save/playerstats.tres"
@export var inv: Inv
@export var stats: PlayerStats

func _ready():
	pass

func _exit_tree():
	save_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func save_game():
	ResourceSaver.save(inv, pathinv)
	ResourceSaver.save(stats, pathstat)
