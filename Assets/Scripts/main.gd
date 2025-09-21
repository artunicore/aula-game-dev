extends Node2D

@onready var teste_label: Label = $CanvasLayer/Control/testeLabel
@onready var camera_posicao: Label = $"CanvasLayer/Control/camera posicao"

@onready var camera_2d: Camera2D = $Camera2D

@onready var spawner: Node2D = $Spawner
var instance_counter = 0
var can_spawn = false
const ESCUDO = preload("res://Assets/PowerUps/escudo.tscn")
const KRYPTONITA = preload("res://Assets/Obstaculos/kryptonita.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	if Input.is_action_pressed("ui_right"):
		teste_label.text = "botão clicado: direita"
	elif Input.is_action_pressed("ui_left"):
		teste_label.text = "botão clicado: esquerda"
	camera_posicao.text = "" + str(camera_2d.position) 

func control_spawner():
	can_spawn = true
	var spawners = spawner.get_children()
	var random_marker = spawners[randi() % spawners.size()]

	if can_spawn:
		instance_counter +=1
		if instance_counter >=10:
			var escudo = ESCUDO.instantiate()
			escudo.global_position = random_marker.global_position
			add_child(escudo)
			instance_counter = 0
		else:
			var krypt = KRYPTONITA.instantiate()
			krypt.global_position = random_marker.global_position
			add_child(krypt)
			


func _on_timer_timeout() -> void:
	can_spawn = false
	control_spawner()
