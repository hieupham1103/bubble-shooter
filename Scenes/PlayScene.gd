extends Node2D

@export var number_balls = 5

@onready var Balls = $Balls
func _ready():
	init()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func pick_random(dict: Dictionary):
	var a = dict.keys()
	a = a[randi() % a.size()]
	return a
	
var Ball = preload("res://Entities/Ball.tscn")

func init():
	var file = "res://Entities/valid_words.json"
	var words_data = JSON.parse_string(FileAccess.get_file_as_string(file))
	var ball_pos = Vector2(36,36)
	for count in range(number_balls):
		var random_name = pick_random(words_data)
		var newBall = Ball.instantiate()
		newBall.position = ball_pos
		newBall.label_text = random_name
		newBall.mask_prefix = words_data[random_name]["prefix"]
		newBall.mask_suffix = words_data[random_name]["suffix"]
		if ball_pos.x + 54 <= 252:
			ball_pos.x += 54
		else:
			ball_pos.x = 36
			ball_pos.y = 36 + 54
		Balls.add_child(newBall)
