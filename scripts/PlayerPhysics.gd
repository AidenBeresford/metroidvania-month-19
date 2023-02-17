extends KinematicBody2D

enum STATE {IDLE, WALK, DASH, JUMP, FALL, DEATH}
enum DIR {LEFT, RIGHT, DOWN, UP}

var velocity = Vector2()
var state = STATE

const SPD = 180
const JMP = -500


func _physics_process(delta):
	
	# state manager should always run first
	state_manager()
	
	# these will be added to a match statement later
	walk()
	jump()
	
	# we always want this to run
	velocity.y += 25
	
	move_and_slide(velocity, Vector2.UP)


func state_manager():
	
	if is_on_floor():
		
		if Input.is_action_pressed("dash"):
			state = STATE.DASH
		else:
			if velocity.x != 0:
				state = STATE.WALK
			else:
				state = STATE.IDLE
	else:
		if velocity.y >= 0:
			state = STATE.JUMP
		else:
			state = STATE.FALL


func walk():
	
	# walk command for idle and walk states
	if Input.is_action_pressed("right"):
		velocity.x = lerp(velocity.x, SPD, .20)
	elif Input.is_action_pressed("left"):
		velocity.x = lerp(velocity.x, -SPD, .20)
	else:
		velocity.x = lerp(velocity.x, 0, .20)


func jump():
	
	# jump command for idle and walk states
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JMP
	
