extends Node2D


@export var player: CharacterBody2D
@export var smoothing_speed: float = 5.0

func _ready():
	# Tenta encontrar o player automaticamente se não for atribuído
	if player == null:
		player = get_tree().get_first_node_in_group("player")

func _process(_delta):
	
	if player:
		# Interpolação suave apenas no eixo X
		global_position.x = player.global_position.x
