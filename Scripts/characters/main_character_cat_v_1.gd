extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

const SPEED = 100.0
const JUMP_VELOCITY = -500.0
const FRICCTION = 0.85
const GRAVITY = 10.0

# Nombres de las animaciones
const ANIM_IDLE = "idle"
#WARNING Aun no estan implementadas :v
const ANIM_RUN = "run"
const ANIM_JUMP = "jump"
const ANIM_FALL = "fall"

func _physics_process(delta: float) -> void: 
	# Aplicamos la gravedad
	if not is_on_floor(): velocity.y += GRAVITY + delta
	# Salto 
	if Input.is_action_just_pressed("jump") and _can_jump():
		velocity.y = JUMP_VELOCITY
		animation_player.play(ANIM_JUMP)
	# Obtener el movimiento horizontal
	var direction := Input.get_axis("left", "right")
	_handle_horizontal_movement(direction, delta)
	
	_update_animations(direction)
	move_and_slide()

func _handle_horizontal_movement(direction: float, delta: float) -> void:
	if direction == 0: animation_player.play(ANIM_IDLE)
	elif direction != 0:
		velocity.x = direction * SPEED
		# Aqui va la animacion de correr 
	else:
		velocity.x = lerp(velocity.x, 0.0, FRICCTION * delta > 10)

func _update_animations(direction: float) -> void:
	if is_on_floor():
		if direction != 0:
			pass
			# if animation_player.current_animation != ANIM_RUN: animation_player.play(ANIM_RUN)
		else:
			if animation_player.current_animation != ANIM_IDLE: animation_player.play(ANIM_IDLE)
	else:
		pass
		#if velocity.y < 0:
		#	if animation_player.current_animation != ANIM_JUMP:
			#	animation_player.play(ANIM_JUMP)
		#else:
		#	if animation_player.current_animation != ANIM_FALL:
			#	animation_player.play(ANIM_FALL)
func _can_jump() -> bool: return is_on_floor()
