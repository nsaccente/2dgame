extends CharacterBody2D

var MOVEMENT_SPEED: int = 300  # speed in pixels/sec
const ANIMATION_DIRECTIONS: int = 8

const INPUT_LEFT: String = "left"
const INPUT_RIGHT: String = "right"
const INPUT_UP:	String = "up"
const INPUT_DOWN: String = "down"

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine: AnimationNodeStateMachinePlayback = (
	animation_tree["parameters/StateMachine/playback"]
)
@onready var sprite_2d: Sprite2D = $Sprite2D
var direction_parser = parse_direction
	
func parse_direction(M: Vector2) -> int:
	var angle = snappedf(M.angle(), PI/(ANIMATION_DIRECTIONS/2)) / (PI/(ANIMATION_DIRECTIONS/2))
	angle = wrapi(int(angle), 0, ANIMATION_DIRECTIONS)
	
	return angle

func type(thing) -> String:
	return type_string(
		typeof(	
			thing
		)
	)

func die(
	velocity: Vector2, 
	mouse_position: Vector2, 
	current_anim: StringName,
):
	pass
	
func hurt(
	velocity: Vector2, 
	mouse_position: Vector2, 
	current_anim: StringName,
):
	pass
	
func idle(
	velocity: Vector2, 
	mouse_position: Vector2, 
	current_anim: StringName,
):
	#var mouse_angle: float = mouse_position.angle()
	#print(mouse_position)
	print(
		parse_direction(
			mouse_position
		)
	)
	#if mouse_angle 
	#if mouse_position[0] >= 0:
		#print(mouse_position[0])
	#else:
		#pass
	
	state_machine.travel("right_idle")
	
func run(
	velocity: Vector2, 
	mouse_position: Vector2, 
	current_anim: StringName,
):
	state_machine.travel("right_run")

func _physics_process(delta):
	var current_anim = state_machine.get_current_node()
	var mouse_position: Vector2 = sprite_2d.get_local_mouse_position()
	
	#if current_anim in ["hurt", "die"]:
		#return
		
	velocity = (
		Input.get_vector(INPUT_LEFT, INPUT_RIGHT, INPUT_UP, INPUT_DOWN)
		 * MOVEMENT_SPEED
	)

	animation_tree.set("parameters/TimeScale/scale", 1)
	#if Input.is_action_just_pressed("attack"):
		#state_machine.travel(attacks.pick_random())
		#return

	if velocity.length() > 0:
		run(velocity, mouse_position, current_anim)
	else:
		idle(velocity, mouse_position, current_anim)
	move_and_slide()
