extends Node2D


@onready var number_balls = $number_balls
@onready var Balls = $GameBoard/Balls

func _ready():
	#init()
	pass

func _process(delta):
	pass

func pick_random(dict: Dictionary):
	var a = dict.keys()
	a = a[randi() % a.size()]
	return a
	
var Ball = preload("res://Entities/Ball.tscn")

func init(debug: bool = false):
	$reset.disabled = true
	for idx in Balls.get_child_count():
		print(Balls.get_child(idx).state)
		Balls.get_child(idx).queue_free()
	
	await get_tree().create_timer(0.2).timeout	
	
	if debug:
		return
	var file = "res://Entities/valid_words.json"
	var words_data = JSON.parse_string(FileAccess.get_file_as_string(file))
	var ball_pos = Vector2(63,36)
	for count in range(int(number_balls.text)):
		var random_name = pick_random(words_data)
		var newBall = Ball.instantiate()
		newBall.state = newBall.ball_state.FREEEZE
		newBall.position = ball_pos
		newBall.label_text = random_name
		newBall.mask_prefix = words_data[random_name]["prefix"]
		newBall.mask_suffix = words_data[random_name]["suffix"]
		if ball_pos.x + 55 <= 260:
			ball_pos.x += 55
		else:
			#print(int(ball_pos.y / 54) % 2)
			if int(ball_pos.y / 54) % 2 == 0:
				ball_pos.x = 36
			else:
				ball_pos.x = 63
			ball_pos.y = ball_pos.y + 54
		#print(newBall.position)
		Balls.add_child(newBall)
	
	$reset.disabled = false

func _on_reset_pressed():
	init()
	

func _on_play_button_pressed():
	$reset.visible = true
	$PlayButton.visible = false
	$Gun.shootable = true
	init()


