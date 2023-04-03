extends KinematicBody2D

export(int) var JUMP_FORCE = -150
export(int) var JUMP_RELEASE_FORCE = -70
export(int) var MAX_SPEED = 100
export(int) var ACCELERATION = 20
export(int) var FRICTION = 20
export(int) var GRAVITY = 4
export(int) var ADDITIONAL_FALL_GRAVITY = 4

var velocity = Vector2.ZERO
	
func _physics_process(delta: float) -> void:
	
	apply_gravity()
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if input.x ==0:
		apply_friction()
	else:
		apply_acceleration(input.x)
		
	# player jump
	if is_on_floor():
		if Input.is_action_pressed("ui_up"):
			velocity.y = JUMP_FORCE
	else:
		if Input.is_action_just_released("ui_up") and velocity.y < JUMP_RELEASE_FORCE:
			velocity.y = JUMP_RELEASE_FORCE
		
		if velocity.y > 0:
			velocity.y += ADDITIONAL_FALL_GRAVITY
			
	
	# apply movement to the player
	velocity = move_and_slide(velocity, Vector2.UP)

func apply_gravity():
	# gravity
	velocity.y += GRAVITY
	velocity.y = min(velocity.y, 200)
	
func apply_friction():
	velocity.x = move_toward(velocity.x, 0, FRICTION)
	
func apply_acceleration(amount):
	velocity.x = move_toward(velocity.x, MAX_SPEED * amount, ACCELERATION)


func _on_DETECTION_body_entered(body: Node) -> void:
	get_tree().reload_current_scene()
