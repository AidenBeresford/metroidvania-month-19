extends KinematicBody2D

enum STATE {IDLE, WALK, DASH, SLIDE, 
JUMP, HOVER, FALL,
HEALING, KNOCKBACK, DEATH}

onready var anim_tree = get_node("AnimationTree")
onready var playback = anim_tree.get("parameters/playback")

var velocity = Vector2()
var state = STATE.IDLE
var dirval = 1
var statelock = false
var coyotelock = true
var doublejump = false

const SPD = 250
const DSH = 2
const JMP = -900
const GRV = 30


func _ready():
	
	$Sprite.flip_h = room.flip
	dirval = room.dir
	velocity = room.velocity
	
	if !grounded():
		velocity.y -= 500
	
	for children in get_parent().get_parent().get_child_count():
		
		if get_parent().get_parent().get_child(children).name == room.last_room:
			
			global_position = get_parent().get_parent().get_child(children).position
	


func _physics_process(delta):
	
	if !statelock:
		state_manager()
	
	else:
		
		if !topblocked() and state == STATE.SLIDE:
			statelock = false 
	
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
			
			if (!$Coyote.is_stopped() and velocity.y > 0) or grounded():
				jump()
			
			if !grounded():
				velocity.y += GRV
				
				if doublejump == true and Input.is_action_just_pressed("jump") and velocity.y > 0:
					
					jump()
					doublejump = false
			
			dash()
		
		STATE.SLIDE:
			playback.travel("Slide")
			
			dash()
		
		STATE.JUMP:
			playback.travel("Jump")
			
			velocity.y += GRV
			turn()
			walk()
		
		STATE.HOVER:
			playback.travel("Hover")
			
			velocity.y += GRV
			turn()
			walk()
		
		STATE.FALL:
			playback.travel("Fall")
			
			velocity.y += GRV
			turn()
			walk()
			
			if !$Coyote.is_stopped():
				jump()
			elif doublejump == true and Input.is_action_just_pressed("jump"):
				jump()
				doublejump = false
		
		STATE.HEALING:
			playback.travel("Heal")
			
			velocity.x = 0
			
			if $Heal.is_stopped():
				$Heal.start(5)
		
		STATE.KNOCKBACK:
			playback.travel("Fall")
			
			velocity.y += GRV*2
			
			if $Knockback.is_stopped():
				$Knockback.start(.5)
		
		STATE.DEATH:
			playback.travel("")
	
	move_and_slide_with_snap(velocity, Vector2(), Vector2.UP)


func state_manager():
	
	if grounded():
		
		coyotelock = false
		doublejump = true
		
		velocity.y = 0
		
		if Input.is_action_pressed("dash"):
			
			if Input.is_action_pressed("down"):
				statelock = true
				state = STATE.SLIDE
			
			else:
				
				if !is_on_wall():
					state = STATE.DASH
				
				else:
					knockback()
			
		elif Input.is_action_pressed("heal"):
			
			state = STATE.HEALING
		
		else:
			
			$Heal.stop()
			
			if meth.absround(velocity.x) < 10:
				state = STATE.IDLE
			else:
				state = STATE.WALK
	
	else:
		
		if coyotelock != true:
			
			$Coyote.start(.1)
		
		coyotelock = true
		
		if !Input.is_action_pressed("dash"):
			
			if velocity.y <= 40 and velocity.y >= -40:
				state = STATE.HOVER
			
			elif velocity.y < 40:
				state = STATE.JUMP
			
			elif velocity.y > 40:
				state = STATE.FALL
		
		else:
			
			if is_on_wall():
				knockback()
			else:
				state = STATE.DASH


func turn():
	
	if Input.is_action_pressed("right"):
		
		$Sprite.flip_h = false
		
		dirval = 1
	
	elif Input.is_action_pressed("left"):
		
		$Sprite.flip_h = true
		
		dirval = -1


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
	if Input.is_action_pressed("jump"):
		velocity.y = JMP


func dash():
	
	velocity.x = SPD*DSH*dirval


func knockback():	
	
	state = STATE.KNOCKBACK
	statelock = true
	
	velocity.x = 300*-dirval
	velocity.y = -600


func grounded():
	
	if $Floor1.is_colliding() or $Floor2.is_colliding():
		return true
	
	else:
		return false


func topblocked():
	
	if $Ceil1.is_colliding() or $Ceil2.is_colliding():
		return true
	
	else:
		return false


func _on_Heal_timeout():
	player.hp += 1
	player.hp = clamp(player.hp, 0, player.maxhp)


func _on_Knockback_timeout():
	
	statelock = false
	velocity.x = 0
	state = STATE.IDLE
