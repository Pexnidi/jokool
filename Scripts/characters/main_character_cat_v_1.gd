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
		- Implementar diferentes animaciones (de la animación de "Nothing" que pase a la animación de "idle")
		 

"""
extends CharacterBody2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_cat: Sprite2D = $CatMoldV1
#region Constantes
@export var MaxSpeed := 300.0
@export var Acceleration := 1800.0
@export var Deceleration := 2200.0 # Desaceleración del personaje
@export var JumpVelocity := -400.0
@export var Gravity := 900.0
# -- Coyote-Time --
@export var CoyoteTime := 0.1
@export var JumpBufferTime := 0.1
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
	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * MaxSpeed, Acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, direction * MaxSpeed, Acceleration * delta)
func _UpdateSpriteDirection(direction: float) -> void: 
	if direction != 0 or Input.is_action_just_pressed("left"):
		LastDirection = direction
		sprite_cat.flip_h = direction < 0
		sprite_cat.flip_h = true
	elif LastDirection != 0:
		sprite_cat.flip_h = LastDirection < 0
		
func _UpdateAnimations(_direction: float, delta: float) -> void:
	if abs(velocity.x) > 10 or not is_on_floor() or _direction != 0:
		IdleTimer = 0.0
		IsInIdleSequence = false
		if animation_player.current_animation == ANIM_NOTHING or animation_player.current_animation == ANIM_IDLE:
			animation_player.stop()
	
	if is_on_floor():
		if abs(velocity.x) > 10:
			if animation_player.current_animation != ANIM_RUN:
				pass
				#animation_player.play(ANIM_RUN)
		else:
			# Player is idle on floor
			if _direction == 0 and animation_player.current_animation != ANIM_NOTHING and animation_player.current_animation != ANIM_IDLE:
				# Start counting idle time
				IdleTimer += delta
				
				# After 2 seconds of inactivity, start the idle sequence
				if IdleTimer >= 2.0 and not IsInIdleSequence:
					IsInIdleSequence = true
					animation_player.play(ANIM_NOTHING)
					
					# Connect to animation finished signal to play idle after Nothing animation
					if not animation_player.animation_finished.is_connected(_on_nothing_animation_finished):
						animation_player.animation_finished.connect(_on_nothing_animation_finished)
	else:
		if velocity.y < 0:
			if animation_player.current_animation != ANIM_JUMP:
				pass
				#animation_player.play(ANIM_JUMP)
		else:
			if animation_player.current_animation != ANIM_FALL:
				pass
				#animation_player.play(ANIM_FALL)

func _on_nothing_animation_finished(anim_name: String) -> void:
	if anim_name == ANIM_NOTHING:
		# Play idle animation after Nothing animation finishes
		animation_player.play(ANIM_IDLE)
# -- Verificación de salto --
func _can_jump() -> bool: return is_on_floor() or CoyoteTimer > 0.0
#endregion
