"""
Tareas:
		- Implementar el tiempo por pulsación (Entre más tiempo presione el botón saltar, saltará más alto) - X
		- Mejor manejo de las pendientes - X
		- Control areo - X
		- Caída más rápida - X
		- Salto amortiguado al pegar con el techo - X
		- Sistema de estados (Solo para las animaciones) - X
		- Un dash, para esquivar los ataques de los enemigos - X
		- Particulas - X
		- Mejor sincronización con las animaciones - X
"""
extends CharacterBody2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_cat: Sprite2D = $CatMoldV1
@onready var cat_animated_idle: Sprite2D = $CatAnimatedIdle

#region Constantes
@export_category("Movimiento")
@export var MaxSpeed := 300.0
@export var Acceleration := 1800.0
@export var Deceleration := 2200.0 # Desaceleración del personaje
@export var JumpVelocity := -400.0
@export var Gravity := 900.0
# -- Coyote-Time --
@export_category("Timers")
@export var CoyoteTime := 0.1
@export var JumpBufferTime := 0.1
@export var IdleTriggerTime = 5.0 # Tiempo de cambio entre las animaciones, en segundos
# -- Animaciones --
const ANIM_IDLE := "idle"
const ANIM_NOTHING := "Nothing"
#WARNING Aún no están implementadas
const ANIM_RUN := "run"
const ANIM_JUMP := "jump"
const ANIM_FALL := "fall"
#endregion
# -- Variables de estado --
var CoyoteTimer := 0.0
var JumpBufferTimer := 0.0
var IdleTimer := 0.0
var IsInIdleSequence := false
var LastDirection := 1.0
#region Funciones
func _physics_process(delta: float) -> void: 
	_ApplyGravity(delta)
	_UpdateTimers(delta)
	_HandleJump()
	
	var direction := Input.get_axis("left", "right")
	_HandleHorizontalMovement(direction, delta)
	_UpdateAnimations(direction, delta)
	_UpdateSpriteDirection()
	
	move_and_slide()
func _ApplyGravity(delta: float) -> void: 
	if not is_on_floor(): 
		velocity.y += Gravity * delta
	elif velocity.y > 0: 
		velocity.y = 0.0
func _UpdateTimers(delta: float) -> void:
	# Cuenta regresiva para el coyote time
	if is_on_floor():
		CoyoteTimer = CoyoteTime
	else:
		CoyoteTimer = max(CoyoteTimer - delta, 0.0)
	# Guardar la entrada del salto por un instante
	if Input.is_action_just_pressed("jump"):
		JumpBufferTimer = JumpBufferTime
	else: 
		JumpBufferTimer = max(JumpBufferTimer - delta, 0.0)
func _HandleJump() -> void: 
	if JumpBufferTimer > 0.0 and CoyoteTimer > 0.0:
		velocity.y = JumpVelocity
		CoyoteTimer = 0.0
		JumpBufferTimer = 0.0
		# animation_player.play(ANIM_JUMP)
func _HandleHorizontalMovement(direction: float, delta: float) -> void:
	var TargetSpeed = direction * MaxSpeed
	var CurrentAcceleration = Acceleration if direction != 0 else Deceleration
	velocity.x = move_toward(velocity.x, TargetSpeed, CurrentAcceleration * delta)

func _UpdateSpriteDirection() -> void: 
	cat_animated_idle.visible = false
	sprite_cat.visible = true
	if Input.is_action_just_pressed("left"):
		sprite_cat.flip_h = true
	elif Input.is_action_just_pressed("right"):
		sprite_cat.flip_h = false
	
func _UpdateAnimations(_direction: float, delta: float) -> void:
	if abs(velocity.x) > 10 or not is_on_floor() or _direction != 0:
		IdleTimer = 0.0
		if animation_player.current_animation == ANIM_IDLE:
			animation_player.stop()
			return
	if is_on_floor() and _direction == 0 and abs(velocity.x) <= 10:
		IdleTimer += delta
		if IdleTimer >= IdleTriggerTime:
			if animation_player.current_animation != ANIM_IDLE:
				sprite_cat.visible = false
				cat_animated_idle.visible = true
				animation_player.play(ANIM_IDLE)
		else:
			if animation_player.current_animation != ANIM_NOTHING:
				cat_animated_idle.visible = false
				sprite_cat.visible = true
				animation_player.play(ANIM_NOTHING)
# -- Verificación de salto --
func _can_jump() -> bool: return is_on_floor() or CoyoteTimer > 0.0
#endregion
