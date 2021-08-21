extends MeshInstance

var velocity = Vector3()
var start_point = Vector3()
export var offset = Vector3(0,0.5,0)
func _ready():
	start_point = global_transform.origin

func _process(delta):
	if global_transform.origin.distance_to(start_point+offset)< 0.1 :
		velocity.y = -1
	elif global_transform.origin.distance_to(start_point) < 0.1:
		velocity.y = 1
	rotation_degrees.y -= 60 * delta
	if rotation_degrees.y >= 360:
		rotation_degrees.y = 0
	global_transform.origin += velocity * delta


func _on_Area_body_entered(body):
	if body.name == "Player":
		print("collect coin")
		GameManager.rep = 1
		queue_free()
