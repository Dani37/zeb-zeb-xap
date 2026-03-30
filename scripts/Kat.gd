extends CharacterBody2D


var SPEED = 50
const JUMP_VELOCITY = -400.0
var timer


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * (delta - 0.01)

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		timer = get_tree().create_timer(0.2)
		velocity.y = JUMP_VELOCITY
	elif Input.is_action_pressed("ui_accept") and timer.time_left >= 0.001:
		velocity.y = JUMP_VELOCITY
	if not Input.is_action_pressed("ui_accept") and not is_on_floor():
		slow_jump()
		if timer:
			timer.time_left = 0
	if Input.is_action_pressed("ui_shift"):
		SPEED = 100
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction == -1 and velocity.x >= -300:
		velocity.x += direction * SPEED
		if velocity.x == -300:
			velocity.x = -300
	elif direction == 1 and velocity.x <= 300:
		velocity.x += direction * SPEED
		if velocity.x == 300:
			velocity.x = 300
	else:
		velocity.x = move_toward(velocity.x, 0, 160)
	if velocity.x < 0:
		$Sprite2D.flip_h = true
	elif velocity.x > 0:
		$Sprite2D.flip_h = false

	move_and_slide()

func slow_jump():
	if velocity.y <= 0:
		velocity.y -= -10
