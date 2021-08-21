extends Enemy


onready var fire_timer = $Projectile_Fire_Time
export (PackedScene) var projectile
onready var animator = $sir_beetle/AnimationPlayer


func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	if state == EnemyState.IDLE and in_range(30):
		state = EnemyState.MOVING
	
	
	if state == EnemyState.MOVING:
		var follow_offset = player.global_transform.origin + Vector3(0,3,0)
		direction = (follow_offset - global_transform.origin).normalized()
	if in_range(20):
		state = EnemyState.ATTACKING
		velocity.x = 0
		velocity.z = 0
		velocity.y = direction.y * speed 
		rotate_to_target(player.global_transform.origin,true)
		
	else:
		state = EnemyState.MOVING
		velocity = direction * speed 
	
	
	velocity = move_and_slide(velocity+y_velocity, Vector3.UP)
	rotate_to_target(global_transform.origin + velocity,true)
	animate()

func animate():
	match(state):
		EnemyState.IDLE:
			animator.play("idle")
		EnemyState.MOVING:
			animator.play("moving")
	
	
	
	
	
func attack():
	var p = projectile.instance()
	p.global_transform.origin = global_transform.origin
	p.target = player.global_transform.origin
	get_tree().get_root().add_child(p)
	

func _on_Projectile_Fire_Time_timeout():
	if in_range(25):
		attack()
