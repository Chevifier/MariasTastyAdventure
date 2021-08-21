extends Area

var speed = 20
var target = Vector3()
var direction = Vector3()
var velocity = Vector3()
# Called when the node enters the scene tree for the first time.
func _ready():
	direction = target - global_transform.origin

func _physics_process(delta):
	velocity = direction.normalized() * speed
	global_transform.origin += velocity * delta
	


func _on_Remove_timer_timeout():
	queue_free()


func _on_sb_projectile_body_entered(body):
	if body.name == "Player":
		body.take_damage(1)
		queue_free()
	else:
		queue_free()
