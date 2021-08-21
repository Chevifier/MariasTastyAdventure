extends Spatial


export var is_moving_platform = false
onready var animator = $AnimationPlayer
export var delay_time = 1
export(NodePath) var target_path

var target = Vector3()

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_moving_platform:
		$Timer.start(delay_time)
		var t = get_node(target_path)
		target = t.transform.origin
		var move : Animation = animator.get_animation("move")
		move.track_set_key_value(0,1,target)
		move.track_set_key_value(0,2,target)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	animator.play("move")
