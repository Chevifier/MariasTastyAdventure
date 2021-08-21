extends Spatial

export var delay_time = 1


func _ready():
	$Stab_Offset_Timer.start(delay_time)




func _on_Area_body_entered(body):
	if body.name == "Player":
		print("kill player")


func _on_Stab_Offset_Timer_timeout():
	$AnimationPlayer.play("stab")

