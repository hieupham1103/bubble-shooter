extends Node2D

@export var pointing = Vector2(1,1)

@export var shootable = true
var is_shooting = false

var balls = []
var Ball = null

func _ready():
	
	var path = "res://Entities/SuffixesAndPrefixes/"
	
	var dir = DirAccess.open(path)
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				pass
			else:
				print("Found file: " + file_name)
				var file_path = path + file_name
				balls.append(load(file_path))
			file_name = dir.get_next()
			
	set_new_ball()
	

func _process(delta):
	if shootable:
		pointing_look()
		update_trajectory(delta)

func pointing_look():
	var mouse_position = get_global_mouse_position()
	pointing = mouse_position - position
	pointing = pointing.normalized()
	$Sprite2D.look_at(mouse_position)


func _input(event):
	if shootable and event.is_action_pressed("shoot"):
		is_shooting = true
		var newBall = Ball
		newBall.velocity = pointing
		newBall.position = position
		get_tree().get_current_scene().find_child("Balls").add_child(newBall)
		shootable = false
		$Timer.start(0.5)


var max_points = 1000

func update_trajectory(delta):
	$Line2D.clear_points()
	var pos = Vector2(0,0)
	var velocity = pointing * 100
	
	for i in max_points:
		$Line2D.add_point(pos)
		var collision_info = $Line2D/CollisionTest.move_and_collide(velocity * delta)
		if collision_info:
			velocity = velocity.bounce(collision_info.get_normal())
		pos += velocity * delta
		$Line2D/CollisionTest.position = pos
		if velocity.y > 0:
			#print(i, velocity)
			break
		if pos.y > 0:
			#print(i, pos)
			break

	
func set_new_ball():
	Ball = balls[randi_range(0,balls.size() - 1)].instantiate()
	$Label.text = Ball.label_text

func _on_timer_timeout():
	#print("adu")
	set_new_ball()
	shootable = true
	is_shooting = false
