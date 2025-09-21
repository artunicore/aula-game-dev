extends Area2D

func _ready() -> void:
	print("===teste debug===")

func _on_area_entered(body: Area2D) -> void:
	if body.is_in_group("obstaculos"):
		print("Corpo sofreu queufree:", body.name)
		body.queue_free()
