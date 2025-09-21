extends CharacterBody2D

@export var move_speed = 300.0
@export var jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_descent : float
@export var idle_timer : float = 5.0
@export var air_attack_cooldown : float = 0.5

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity: float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

@onready var jump_count = 0
@onready var airattackcount = 0

var isDead = false  
var is_attacking = false
var is_jumping = false
var can_jump = true
var can_attack = true
var can_attack_in_air = true 

enum {IDLE1, IDLE2_TRANSICAO, IDLE2, WALK, JUMP, FALL, ATTACK}
var current_state = IDLE1

@onready var anim: AnimationPlayer = $anim
@onready var sprite: Sprite2D = $sprite
@onready var hitbox: Area2D = $hitbox
@onready var air_attack_timer: Timer = $air_attack_timer 

func _ready() -> void:
	change_state(IDLE1)

func _physics_process(delta: float) -> void:
	if not isDead:
		velocity.y += calcular_gravidade() * delta
	if not isDead and not is_attacking:
		
		var direction = Input.get_axis("esquerda", "direita")
		if direction != 0:
			if direction < 0:
				sprite.flip_h = true
				hitbox.position.x = -23
			else:
				sprite.flip_h = false
				hitbox.position.x = 43
			velocity.x = direction * move_speed
			change_state(WALK)
		else:
			velocity.x = move_toward(velocity.x, 0, move_speed)
			if is_on_floor() and velocity.x == 0:
				is_jumping = false
				change_state(IDLE1)
	
		if Input.is_action_just_pressed("pulo") and (can_jump or jump_count < 1) and (can_attack and airattackcount < 1):
			jump_count += 1
			airattackcount += 1
			jump()

		if is_on_floor():
			airattackcount = 0
			jump_count = 0
			can_jump = true
			is_jumping = false
			can_attack_in_air = true 
			
			if velocity.x == 0 and current_state not in [IDLE1, IDLE2_TRANSICAO, IDLE2]:
				change_state(IDLE1)
				
		elif velocity.y < 0:
			change_state(JUMP)
		elif velocity.y > 0:
			change_state(FALL)
	
	if Input.is_action_pressed("ataque") and can_attack and (is_on_floor() or can_attack_in_air):
		attack()

	move_and_slide()

func calcular_gravidade() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func jump() -> void:
	can_jump = false
	change_state(JUMP)
	velocity.y = jump_velocity
	is_jumping = true

func attack() -> void:
	can_attack = false
	is_attacking = true
	change_state(ATTACK)
		
func _on_air_attack_timer_timeout() -> void:
	can_attack_in_air = true

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name in ["AttackIdle", "AttackWalk", "AttackJump"]:
		is_attacking = false
		can_attack = true
		if is_on_floor():
			if velocity.x == 0:
				change_state(IDLE1)
			else:
				change_state(WALK)
		else:
			if velocity.y > 0:
				change_state(FALL)
			else:
				change_state(JUMP)

func change_state(new_state: int) -> void:
	if current_state == new_state:
		return
	
	current_state = new_state
	
	match current_state:
		IDLE1:
			anim.play("Idle1")
		IDLE2:
			anim.play("Idle2")
		WALK:
			anim.play("Walk")
		JUMP:
			anim.play("Jump")
		FALL:
			anim.play("Fall")
		ATTACK:
			if is_on_floor():
				if velocity.x == 0:
					anim.play("AttackIdle")
				else:
					anim.play("AttackWalk")
			else:
				anim.play("AttackJump")
				can_attack_in_air = false
				air_attack_timer.start(air_attack_cooldown)
