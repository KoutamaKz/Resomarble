extends CharacterBody2D

@export var inv: Inv
@export var stats: PlayerStats

@onready var maxhealth = stats.maxlife
@onready var damage = stats.strength
@onready var energy = stats.energy
@onready var posi = stats.position

var knockback_vector := Vector2.ZERO
var _state_machine
var is_knockback: bool = false
var is_attacking: bool = false
var clickabutton: bool = false
@onready var health: int = maxhealth
var timer: SceneTreeTimer

@export_category("Variables")
@export var _move_speed: float = 64.0
@export var _acceleration: float = 0.2
@export var _friction: float = 0.2

@export_category("Objects")
@onready var texture: Sprite2D = $Texture
@export var _animation_tree: AnimationTree = null
@export var attack_timer: Timer = null

@onready var healthbar = $UI/Healthbar

func _ready() -> void:
	global_position = posi
	timer = null
	_animation_tree.active = true
	_state_machine = _animation_tree["parameters/playback"]
	healthbar.update_bar(maxhealth, maxhealth, 0)
	
func _exit_tree():
	stats.position = global_position
	
func _physics_process(delta: float) -> void:
	_move()
	_attack()
	_animate()
	move_and_slide()
	
func _move() -> void:
	var _direction: Vector2 = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)
	if is_knockback:
			_direction = Vector2.ZERO
	
	if _direction != Vector2.ZERO:
		_animation_tree["parameters/idle/blend_position"] = _direction
		_animation_tree["parameters/walk/blend_position"] = _direction
		_animation_tree["parameters/attack/blend_position"] = _direction
		
		velocity.x = lerp(velocity.x, _direction.normalized().x * _move_speed, _acceleration)
		velocity.y = lerp(velocity.y, _direction.normalized().y * _move_speed, _acceleration)
		return
		
	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector
	velocity.x = lerp(velocity.x, _direction.normalized().x * _move_speed, _friction)
	velocity.y = lerp(velocity.y, _direction.normalized().y * _move_speed, _friction)

func _attack() -> void:
	if Input.is_action_just_pressed("attack") and not is_attacking and not clickabutton:
		set_physics_process(false)
		attack_timer.start()
		is_attacking = true
		

func _animate() -> void:
	if is_attacking:
		_state_machine.travel("attack")
		return
		
	if velocity.length() > 5:
		_state_machine.travel("walk")
		return
		
	_state_machine.travel("idle")
	pass



func _on_attack_timer_timeout() -> void:
	is_attacking = false
	set_physics_process(true)
	


func _on_attack_body_entered(body):
	if body.is_in_group("enemy"):
		var direct = (body.global_position - global_position).normalized()
		body.update_health(damage, Vector2(direct.x * 300, direct.y * 300))
		
func start_timer(duration: float):
	# Cria o temporizador e conecta o sinal `timeout` somente quando necessário
	timer = get_tree().create_timer(duration)
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))

func _on_timer_timeout():
	# Função chamada quando o temporizador atinge 0
	is_knockback = false
	texture.modulate = Color(1, 1, 1, 1)
	
func update_health(dmg, knockback_force := Vector2.ZERO, duration := 0.50) -> void:
	var prevh = health
	health -= dmg
	healthbar.update_bar(health, maxhealth, prevh)
	knockback_vector = knockback_force
	texture.modulate = Color(1, 0.5, 0.5, 1)
	var knockback_tween := get_tree().create_tween()
	knockback_tween.tween_property(self, "knockback_vector", Vector2.ZERO, duration)
	start_timer(0.1)
	is_knockback = true

func collect(item):
	pass
