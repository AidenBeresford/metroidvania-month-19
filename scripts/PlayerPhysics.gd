extends KinematicBody2D

enum STATE {IDLE, WALK, DASH, JUMP, FALL, DEATH}
enum DIR {LEFT, RIGHT}
var velocity = Vector2()
var state = STATE
var dir = DIR.RIGHT

const SPD = 180
const DSH = 1.5
const JMP = -500
const GRV = -25


func _physics_process(delta):
	
	velocity.y += 25
	
	state_manager()
	
	# player abilities based on state
	match state:
		
		STATE.IDLE:
			walk()
			jump()
		
		STATE.WALK:
			walk()
			jump()
		
		STATE.DASH:
			jump()
			dash()
		
		STATE.JUMP:
			walk()
		
		STATE.FALL:
			walk()
		
		STATE.DEATH:
			pass
	
	move_and_slide(velocity, Vector2.UP)


func state_manager():
	
	if is_on_floor():
		
		velocity.y = 0
		
		if Input.is_action_pressed("dash"):
			state = STATE.DASH
		else:
			if velocity.x != 0:
				state = STATE.WALK
			else:
				state = STATE.IDLE
	elif !Input.is_action_pressed("dash"):
		if velocity.y >= 0:
			state = STATE.JUMP
		else:
			state = STATE.FALL
	
	if Input.is_action_pressed("right"):
		dir = DIR.RIGHT
	elif Input.is_action_pressed("left"):
		dir = DIR.LEFT


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

func dash():
	
	if Input.is_action_pressed("dash"):
		if dir == DIR.LEFT:
			velocity.x = SPD*-DSH
		elif dir == DIR.RIGHT:
			velocity.x = SPD*DSH
	
	if Input.is_action_just_released("dash"):
		velocity.x = 0
