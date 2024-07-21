extends ProgressBar

var mini = 100.0
var mini2 = 100.0
var h = 0
var mh = 0

@export_category("Objects")
@export var body: CharacterBody2D = null
@onready var healthbar: ProgressBar = $Damagebar
@onready var timer = $Timer
@onready var text = $HText

func _ready():
	set_process(true)

func update_bar(_health, _maxhealth, prevh) -> void:
	h = _health
	mh = _maxhealth
	if _health < prevh:
		mini = (float(_health) / float(_maxhealth)) * 100
		timer.start()

func _process(delta):
	value = lerp(value, mini, 5.0 * delta)
	healthbar.value = lerp(healthbar.value, mini2, 5.0 * delta)
	text.bbcode_text = "{0} / {1}".format([h,mh])
	if h <= 0:
		h = 0

func _on_timer_timeout():
	mini2 = (float(h) / float(mh)) * 100
