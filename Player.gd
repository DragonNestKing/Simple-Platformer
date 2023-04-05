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
	if not is_on_wall():
		apply_gravity(200)
	elif is_on_wall():
		apply_gravity(25)
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	
	if input.x ==0:
		apply_friction()
		$AnimatedSprite.animation = "Idle"
	else:
		apply_acceleration(input.x)
		$AnimatedSprite.animation = "Run"
		if input.x < 0:
			$AnimatedSprite.flip_h = false
		elif input.x > 0:
			$AnimatedSprite.flip_h = true
		
	# player jump
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = JUMP_FORCE
	elif is_on_wall() and not is_on_floor():
		$AnimatedSprite.animation = "On Wall"
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = JUMP_FORCE
			if velocity.x > 0:
				velocity.x = -150
			elif velocity.x < 0:
				velocity.x = 150
	else:
		$AnimatedSprite.animation = "Jump"
		if Input.is_action_just_released("ui_up") and velocity.y < JUMP_RELEASE_FORCE:
			velocity.y = JUMP_RELEASE_FORCE
		
		if velocity.y > 0:
			velocity.y += ADDITIONAL_FALL_GRAVITY
			
	
	# apply movement to the player
	var was_in_air = not is_on_floor()
	velocity = move_and_slide(velocity, Vector2.UP)
	var just_landed = is_on_floor() and was_in_air
	if just_landed:
		$AnimatedSprite.animation = "Run"
		$AnimatedSprite.frame = 1

func apply_gravity(power):
	# gravity
	velocity.y += GRAVITY
	velocity.y = min(velocity.y, power)
	
func apply_friction():
	velocity.x = move_toward(velocity.x, 0, FRICTION)
	
func apply_acceleration(amount):
	velocity.x = move_toward(velocity.x, MAX_SPEED * amount, ACCELERATION)


func _on_DETECTION_body_entered(body: Node) -> void:
	get_tree().reload_current_scene()
