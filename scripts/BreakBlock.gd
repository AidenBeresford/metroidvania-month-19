extends Area2D


func _ready():
	get_parent().get_node("AnimationPlayer").play("initialize")


func _on_Area_body_entered(body):
	
	for collisions in get_overlapping_bodies():
		if collisions.get_parent().name == "Player":
			if collisions.state == collisions.STATE.DASH or collisions.state == collisions.STATE.KNOCKBACK:
				get_parent().get_node("AnimationPlayer").play("break")
