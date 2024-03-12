extends RigidBody2D

enum ball_state{
	FREEEZE,
	BOUNCH
}

@export var state: ball_state = ball_state.BOUNCH
@export var speed = 300
@export var velocity = Vector2(1,-1)
@export var label_text = ""
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
		

func _destroy():
	var effect = load("res://Entities/destroy_particles.tscn").instantiate()
	effect.emitting = true
	effect.position = global_position
	get_tree().current_scene.add_child(effect)
	queue_free()

func _on_detect_near_area_entered(area):
	for type_name in mask_suffix:
		#print(area.label_text)
		if type_name == area.label_text:
			#print(label_text, ": die")
			_destroy()
