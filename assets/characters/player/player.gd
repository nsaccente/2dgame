extends CharacterBody2D

var MOVEMENT_SPEED: int = 300  # speed in pixels/sec

const INPUT_LEFT: String = "left"
const INPUT_RIGHT: String = "right"
const INPUT_UP:	String = "up"
const INPUT_DOWN: String = "down"

@onready var state_machine = $AnimationTree["parameters/playback"]

func run():
	state_machine.travel("run_right")

func _physics_process(delta):
	var current_anim = state_machine.get_current_node()
	#if current_anim in ["hurt", "die"]:
		#return
		
	velocity = (
		Input.get_vector(INPUT_LEFT, INPUT_RIGHT, INPUT_UP, INPUT_DOWN)
		 * MOVEMENT_SPEED
	)
	
	
	#if Input.is_action_just_pressed("attack"):
		#state_machine.travel(attacks.pick_random())
		#return
		
	# True if the cursor is to the left of the player
	var look_left = $Sprite2D.get_local_mouse_position()[0] < 0
	$Sprite2D.flip_h = look_left
	
	if velocity.x != 0:
		$Sprite2D.scale.x = sign(velocity.x)
	if velocity.length() > 0:
		run()
	else:
		state_machine.travel("idle_right")
	move_and_slide()
