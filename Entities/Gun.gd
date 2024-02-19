extends Node2D

@export var pointing = Vector2(1,1)

var shootable = true
var is_shooting = false

var rng = RandomNumberGenerator.new()
func _process(delta):
	pointing_look()

var Balls = [preload("res://Entities/Suffixes/tion.tscn"),
			preload("res://Entities/Suffixes/tive.tscn"),
			preload("res://Entities/Suffixes/ment.tscn")
			]
var Ball = Balls[rng.randi_range(0,Balls.size() - 1)].instantiate()

func _ready():
	$Label.text = Ball.label_text

func _input(event):
	if shootable and event.is_action_pressed("shoot"):
		is_shooting = true
		var newBall = Ball
		newBall.velocity = pointing
		newBall.position = position
		get_tree().get_current_scene().find_child("Balls").add_child(newBall)
		shootable = false
		$Timer.start(0.5)
		
func pointing_look():
	var mouse_position = get_global_mouse_position()
	pointing = mouse_position - position
	pointing = pointing.normalized()
	$Sprite2D.look_at(mouse_position)

var empty_ball = preload("res://Entities/GhostBall.tscn")

func _predict():
	if is_shooting:
		return
	shootable = false
	var newBall = empty_ball.instantiate()
	newBall.velocity = pointing
	newBall.position = position
	get_tree().get_current_scene().find_child("Balls").add_child(newBall)
	shootable = true

func _on_timer_timeout():
	#print("adu")
	shootable = true
	Ball = Balls[rng.randi_range(0,Balls.size() - 1)].instantiate()
	$Label.text = Ball.label_text
	is_shooting = false


func _on_predict_timer_timeout():
	_predict()
