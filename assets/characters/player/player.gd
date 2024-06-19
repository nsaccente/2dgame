extends CharacterBody2D

var speed = 5000  # speed in pixels/sec

func _physics_process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed * delta
	
	print(
		get_global_mouse_position()
	)

	
	move_and_slide()
