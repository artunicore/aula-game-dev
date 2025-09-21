extends Area2D

@onready var tempodeaura: Timer = $tempodeaura

func _ready() -> void:
	tuim()
	tempodeaura.autostart = true

func _on_tempodeaura_timeout() -> void:
	queue_free()

func tuim():
	var tween : Tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.4, 1.4), 0.5).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(2.0, 2.0), 0.5).set_ease(Tween.EASE_IN)
	tween.set_loops()

func _on_area_entered(body: Area2D) -> void:
	if body.is_in_group("obstaculos"):
		print("Destruindo obstáculo: ", body.name)
		if body.has_method("die"):
			body.die()
