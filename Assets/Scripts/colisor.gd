extends Area2D
var camera : Camera2D
@export var move_speed: float = 150.0

func _ready():
	# Tenta encontrar o player automaticamente se não for atribuído
	if camera == null:
		camera = get_tree().get_first_node_in_group("camera")

func _physics_process(_delta) -> void:
	if camera:
		# Interpolação suave apenas no eixo X
		global_position.x = camera.global_position.x
	
