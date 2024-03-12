extends RigidBody2D

enum ball_state{
	FREEEZE,
	BOUNCH
}

@export var state: ball_state = ball_state.BOUNCH
@export var speed = 300
@export var velocity = Vector2(1,-1)
@export var label_text = ""

func _ready():
	$Label.text = label_text
	$detect_near.label_text = label_text

var bounce_count = 0

func _physics_process(delta):
	if bounce_count >= 4:
		_destroy()
	if state == ball_state.BOUNCH:
		var collision_info = move_and_collide(speed * velocity * delta)
		if collision_info:
			velocity = velocity.bounce(collision_info.get_normal())
			bounce_count += 1
			if velocity.y > 0:
				state = ball_state.FREEEZE
				_destroy()
		

func _destroy():
	await get_tree().create_timer(0.1).timeout	
	queue_free()


func _on_detect_near_area_entered(area):
	#print(area)
	_destroy()

