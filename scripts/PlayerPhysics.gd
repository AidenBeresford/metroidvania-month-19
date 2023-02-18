extends KinematicBody2D

enum STATE {IDLE, WALK, DASH, JUMP, FALL, DEATH}
enum DIR {LEFT, RIGHT}

onready var anim_tree = get_node("AnimationTree")
onready var playback = anim_tree.get("parameters/playback")

var velocity = Vector2()
var state = STATE
var dir = DIR.RIGHT

const SPD = 180
const DSH = 1.5
const JMP = -700
const GRV = 20


func _physics_process(delta):
	
	velocity.y += GRV
	
	state_manager()
	print(velocity)
	
	# player abilities based on state
	match state:
		
		STATE.IDLE:
			playback.travel("Idle")
			
			turn()
			walk()
			jump()
		
		STATE.WALK:
			playback.travel("Walk")
			
			turn()
			walk()
			jump()
		
		STATE.DASH:
			playback.travel("Dash")
			
			jump()
			dash()
		
		STATE.JUMP:
			turn()
			walk()
		
		STATE.FALL:
			turn()
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
			if absround(velocity.x) < 10:
				state = STATE.IDLE
			else:
				state = STATE.WALK
	elif !Input.is_action_pressed("dash"):
		if velocity.y >= 0:
			state = STATE.JUMP
		else:
			state = STATE.FALL


func turn():
	
	if Input.is_action_pressed("right"):
		$Sprite.flip_h = false
		dir = DIR.RIGHT
	elif Input.is_action_pressed("left"):
		$Sprite.flip_h = true
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


func absround(num):
	return abs(round(num))
