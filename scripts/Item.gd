extends Node2D

export var ability : String


func _ready():
	
	$AnimationPlayer.play("Idle")
	
	if player.current_items[ability] == true:
		queue_free()


func _on_Area2D_body_entered(body):
	
	for bodies in $Item.get_overlapping_bodies():
		
		if bodies.get_parent().name == "Player":
			player.current_items[ability] = true
			$Control.visible = true
