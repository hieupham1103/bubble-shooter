extends RigidBody2D

enum ball_state{
	FREEEZE,
	BOUNCH
}

enum type_word{
	PREFIX,
	SUFFIX,
	NONE
}


@export var state: ball_state = ball_state.BOUNCH
@export var speed = 300
@export var velocity = Vector2(1,-1)
@export var label_text = ""
@export var type: type_word = type_word.NONE
@export var mask_prefix: Array
@export var mask_suffix: Array

func _ready():
	$Label.text = label_text
	$detect_near.label_text = label_text

var bounce_count = 0

func _physics_process(delta):
	if bounce_count >= 4:
		_destroy()
	if velocity.y > 0:
		state = ball_state.FREEEZE
	if state == ball_state.FREEEZE:
		$detect_near/CollisionShape2D.disabled = false
	if state == ball_state.BOUNCH:
		var collision_info = move_and_collide(speed * velocity * delta)
		if collision_info:
			velocity = velocity.bounce(collision_info.get_normal())
			bounce_count += 1
	if type != type_word.NONE and state == ball_state.FREEEZE:
		_destroy()
		

func _destroy():
	await get_tree().create_timer(0.2).timeout	
	queue_free()
	
func _on_detect_near_area_entered(area):
	#print(area.label_text)
	if type != type_word.NONE:
		_destroy()
	else:
		for type_name in mask_suffix:
			if type_name == area.label_text:
				print(label_text, ": die")
				_destroy()
	state = ball_state.FREEEZE


