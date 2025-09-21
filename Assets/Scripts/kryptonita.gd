extends Area2D

@onready var speed : float = 2.0
@onready var anim: AnimatedSprite2D = $anim
@onready var colisao: CollisionShape2D = $colisao

func _ready() -> void:
	add_to_group("obstaculos")

func _physics_process(_delta: float) -> void:
	global_position.x -= speed 

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and colisao.disabled == false:
		body.die()
		die()

func die():   
	anim.play("estilhaço")
	colisao.disabled = true
	speed = 0.0

func _on_anim_animation_finished() -> void:
	self.queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("aura"):
		print("Colidiu")
		die()
