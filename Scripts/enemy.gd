extends CharacterBody2D
class_name Enemy

@export_category("Stats")
@export var health = 100
@export var damage = 10
@export var vel = 40

var knockback_vector := Vector2.ZERO
var is_knockback: bool = false
var player_ref = null
var state_machine = null
var idle: bool = false
var g_health = health
var timer: SceneTreeTimer

@export_category("Objects")
@onready var healthbar: ProgressBar = $Healthbar
@onready var texture: Sprite2D = $Texture
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree

func _ready() -> void:
	healthbar.update_bar(g_health, health, 0)
	animation_tree.active = true
	state_machine = animation_tree["parameters/playback"]

func _on_detection_body_entered(body) -> void:
	if body.is_in_group("player"):
		player_ref = body


func _on_detection_body_exited(body) -> void:
	if body.is_in_group("player"):
		player_ref = null

func _physics_process(delta: float) -> void:
	_animate()
	if knockback_vector != Vector2.ZERO:
			velocity = knockback_vector
	if player_ref == null:
		idle = true
	elif player_ref != null:
		idle = false
		var direction: Vector2 = global_position.direction_to(player_ref.global_position)
		var distance: float = global_position.distance_to(player_ref.global_position)
		if is_knockback:
			direction = Vector2.ZERO
		if distance < 3:
			return
		else:
			velocity = direction * vel
		if knockback_vector != Vector2.ZERO:
			velocity = knockback_vector
		move_and_slide()
		if direction != Vector2.ZERO:
			animation_tree["parameters/idle/blend_position"] = direction
			animation_tree["parameters/walk/blend_position"] = direction
			animation_tree["parameters/attack/blend_position"] = direction
		if distance < 20:
			state_machine.travel("attack")
			return

func _animate() -> void:
	if idle:
		state_machine.travel("idle")
		return
	if velocity.length() > 5:
		state_machine.travel("walk")
		return
	
	pass

func start_timer(duration: float):
	# Cria o temporizador e conecta o sinal `timeout` somente quando necessário
	timer = get_tree().create_timer(duration)
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))

func _on_timer_timeout():
	# Função chamada quando o temporizador atinge 0
	is_knockback = false
	texture.modulate = Color(1, 1, 1, 1)

func _on_attack_body_entered(body):
	if body.is_in_group("player"):
		var direct = (player_ref.global_position - global_position).normalized()
		body.update_health(damage, Vector2(direct.x * 300, direct.y * 300))
		
func update_health(dmg, knockback_force := Vector2.ZERO, duration := 0.25) -> void:
	var prevh = g_health
	g_health -= dmg
	healthbar.update_bar(g_health, health, prevh)
	knockback_vector = knockback_force
		
	var knockback_tween := get_tree().create_tween()
	knockback_tween.tween_property(self, "knockback_vector", Vector2.ZERO, duration)
	texture.modulate = Color(1, 0.5, 0.5, 1)
	start_timer(0.2)
	is_knockback = true
