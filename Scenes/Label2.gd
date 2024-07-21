extends Button

@onready var inv = $".."
# Defina o intervalo de tempo para considerar um clique como duplo clique
const DOUBLE_CLICK_TIME = 300000  # Tempo em microssegundos (300000 microssegundos = 0.3 segundos)
var last_click_time = -1

func _ready():
	pass

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			var mouse_pos = get_global_mouse_position()
			if get_global_rect().has_point(mouse_pos):
				_on_Right_Click()
			
func _on_Right_Click():
	inv.right_click()

func _on_Double_Click():
	inv.double_click()

func _on_pressed():
	var current_time = Time.get_ticks_usec()  # Obtém o tempo atual em microssegundos
	if last_click_time > 0 and (current_time - last_click_time) < DOUBLE_CLICK_TIME:
		# Se o tempo desde o último clique for menor que o intervalo definido, é um duplo clique
		_on_Double_Click()
	last_click_time = current_time
