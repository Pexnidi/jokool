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
		- Agreagar más animaciónes para darle coherancia al personaje, por ejemplo, en la animación de idle, al finalizar quedaría bien una animación de kepReading, dónde en lugar de volver a guardar el libro, solo siga leyendo el libro.
		Y después las animaciones de sleeping y sitting, para que sea más gracioso :v
"""
extends CharacterBody2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_cat_Nothing: Sprite2D = $CatAnimationNothing
@onready var sprite_cat_idle: Sprite2D = $CatAnimationIdle

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
@export var IdleTriggerTime = 1.0 # Tiempo de cambio entre las animaciones, en segundos
# -- Animaciones --
const ANIM_IDLE := "idle"
const ANIM_NOTHING := "Nothing"
#WARNING Aún no están implementadas
const ANIM_KEEPREADING = "keepReading"
const ANIM_RUN := "run"
const ANIM_JUMP := "jump"
const ANIM_FALL := "fall"
#endregion
# -- Variables de estado --
var CoyoteTimer := 0.0
var JumpBufferTimer := 0.0
var IdleTimer = 0.0
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
	if Input.is_action_just_pressed("left"):
		sprite_cat_Nothing.flip_h = true
		sprite_cat_idle.flip_h = true
	elif Input.is_action_just_pressed("right"):
		sprite_cat_Nothing.flip_h = false
		sprite_cat_idle.flip_h = false
	
func _UpdateAnimations(_direction: float, delta: float) -> void:
	if abs(velocity.x) > 0 or not is_on_floor() or _direction:
		IdleTimer = 0.0
		sprite_cat_idle.visible = false
		
		if sprite_cat_Nothing.visible:
			sprite_cat_Nothing.visible = true
			animation_player.play(ANIM_NOTHING)
		else:
			sprite_cat_Nothing.visible = true
			animation_player.play(ANIM_NOTHING)
		return
	if abs(velocity.x) == 0 and is_on_floor(): IdleTimer += delta
	
	if IdleTimer >= 5.0 and sprite_cat_Nothing:
		sprite_cat_Nothing.visible = false
		sprite_cat_idle.visible = true
		animation_player.play(ANIM_IDLE)


# -- Verificación de salto --
func _can_jump() -> bool: return is_on_floor() or CoyoteTimer > 0.0
#endregion
