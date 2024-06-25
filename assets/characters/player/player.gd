extends CharacterBody2D

## Base player movement speed.
const BASE_MOVEMENT_SPEED: int = 300

## Set to number of sprite orientations; make sure to label your animations 
## from 0 through (ANIMATION_DIRECTIONS-1), starting at 3 o'clock.
const ANIMATION_DIRECTIONS: int = 2

## Input configuration, update values with InputMap action names
const INPUT: Dictionary = {
	"move_left": "left",
	"move_right": "right",
	"move_up": "up",
	"move_down": "down",
}

# Player state variables; no need to edit
var movement_speed: int = BASE_MOVEMENT_SPEED  # speed in pixels/sec
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine: AnimationNodeStateMachinePlayback = (
	animation_tree["parameters/StateMachine/playback"]
)
@onready var sprite_2d: Sprite2D = $Sprite2D
	
	
## Converts a vector into a `num_directions` slices, and returns the slice
## number where the vector is in.
## https://kidscancode.org/godot_recipes/4.x/2d/8_direction/
func parse_direction(V: Vector2, num_directions=ANIMATION_DIRECTIONS) -> int:
	var angle = (
		snappedf(
			V.angle(), 
			PI/(num_directions/2),
		) 
		/ (PI/(num_directions/2))
	)
	return wrapi(int(angle), 0, num_directions)


## Handles idle animation
func idle(
	velocity: Vector2, 
	mouse_position: Vector2, 
	current_anim: StringName,
) -> void:
	state_machine.travel("idle_" + str(parse_direction(mouse_position)))


## Handles run animation
func run(
	velocity: Vector2, 
	mouse_position: Vector2, 
	current_anim: StringName,
) -> void:
	#animation_tree.set("parameters/TimeScale/scale", 1)
	state_machine.travel("run_" + str(parse_direction(mouse_position)))


func _physics_process(delta):
	var current_anim = state_machine.get_current_node()
	var mouse_position: Vector2 = sprite_2d.get_local_mouse_position()
	
	velocity = (
		Input.get_vector(
			INPUT["move_left"], 
			INPUT["move_right"], 
			INPUT["move_up"],
			INPUT["move_down"],
		) * movement_speed
	)

	if velocity.length() > 0:
		run(velocity, mouse_position, current_anim)
	elif current_anim in ["hurt", "die"]:
		return
	elif Input.is_action_just_pressed("attack"):
		return
	else:
		idle(velocity, mouse_position, current_anim)
	move_and_slide()
