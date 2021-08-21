extends Spatial

export var time_delay = 1.0
func _ready():
	$Chop_Offset_Timer.start(time_delay)
	
	
func _on_Chop_Timer_timeout():
	$AnimationPlayer.play("chop")
	

func _on_Area_body_entered(body):
	if body.name == "Player":
		print("kill player")
