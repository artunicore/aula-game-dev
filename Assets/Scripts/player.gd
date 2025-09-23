extends CharacterBody2D

#movimento
@export var move_speed = 100.0
@export var jump_force = -10.0
@export var gravidade = 30.0

#dash
@export var dash_Spd = 200
var can_dash = false
@onready var dash_timer: Timer = $dash_timer
const AURA = preload("res://Assets/PowerUps/aura.tscn")
@onready var aurapos: Marker2D = $aurapos
var aura_instance = null 

#morte
var can_move = true
#anim
@onready var anim: AnimatedSprite2D = $anim

func _physics_process(delta: float) -> void:
	
	if can_move:
		
		# movimentacao cima e baixo
		if Input.is_action_pressed("ui_up"):
			velocity.y = jump_force
		elif Input.is_action_pressed("ui_down"):
			velocity.y = -jump_force
		else:
			velocity.y = 0
		
		var direction = Input.get_axis("ui_left","ui_right")
		if direction !=0:
			if direction < 0:
				anim.play("freando")
				velocity.x = (direction * move_speed) / 2
				can_dash = false
			velocity.x = direction * move_speed
		else:
			velocity.x = move_speed
			anim.play("Voando")
		
		if can_dash:
			velocity.x += move_speed + dash_Spd

	else:
		velocity.x = 0
		velocity.y = 0
		die()
	move_and_slide()


# Função para ativar o dash
func activate_dash():
	can_dash = true
	if can_dash:
		aura_instance = AURA.instantiate()
		call_deferred("add_child",aura_instance)
		aura_instance.position = aurapos.position
		dash_timer.start()
		var tween : Tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_ELASTIC)
		tween.tween_property(anim, "modulate", Color.RED, 1)
		tween.tween_property(anim, "modulate", Color.WHITE, 0.5)
		
func die():
	anim.play("Morte")
	can_move = false


func _on_dash_timer_timeout() -> void:
	can_dash = false
	anim.modulate = Color.WHITE

	if aura_instance:
		aura_instance.queue_free()
		aura_instance = null
