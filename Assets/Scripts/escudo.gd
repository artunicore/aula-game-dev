extends Area2D
@export var vel : float = 10.0
@onready var anim: AnimatedSprite2D = $anim

func _ready() -> void:
	tuim()
	 
func tuim():
	var tween : Tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.4, 1.4), 0.5).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.5).set_ease(Tween.EASE_IN)
	tween.set_loops()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.has_method("activate_dash"):
		body.activate_dash()
		
		die()

func die():
	var tween : Tween = create_tween()
	tween.tween_property(self, "rotation", rad_to_deg(45.0), 0.5).set_ease(Tween.EASE_OUT)
	anim.play("plim")

func _on_animated_sprite_2d_animation_finished() -> void:
	self.queue_free()
