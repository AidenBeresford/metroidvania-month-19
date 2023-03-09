extends Node2D

onready var spear = load("res://scenes/enemies/ARN_PROJECTILE.tscn")
var dirval = 1


func _ready():
	
	if $Sprite.flip_h == true:
		dirval = -1
	else:
		dirval = 1


func _on_Timer_timeout():
	
	$AnimationPlayer.play("Attack")
	$Throw.start(0.35)
	$Reset.start(0.5)


func _on_Throw_timeout():
	
	var projectile = spear.instance()
	add_child(projectile)
	
	projectile.throw(dirval)
	


func _on_Reset_timeout():
	$AnimationPlayer.play("Idle")
