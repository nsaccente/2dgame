extends CharacterBody2D

var SPEED = 10000  # speed in pixels/sec
@onready var state_machine = $AnimationTree["parameters/playback"]
@onready var sprite_2d = $Sprite2D

func _physics_process(delta):
	var current = state_machine.get_current_node()
	print(current)
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * SPEED * delta
	
	# True if the cursor is to the left of the player
	var look_left = sprite_2d.get_local_mouse_position()[0] < 0
	sprite_2d.flip_h = look_left
	
	if velocity.length() > 0:
		state_machine.travel("run")
	else:
		state_machine.travel("idle")
	
	move_and_slide()
#
