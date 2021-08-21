extends Enemy

onready var animator = $mister_bug/AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	if state == EnemyState.IDLE and in_range(10):
		state = EnemyState.ALERTED

	if state == EnemyState.ATTACKING:
		direction = (player.global_transform.origin - global_transform.origin).normalized()
		direction.y = 0
		velocity = direction * speed 
	
	if not is_on_floor():
		y_velocity.y -= gravity * delta
	else:
		y_velocity.y = -0.1
		
	rotate_to_target(global_transform.origin+velocity,true)
	
	
	velocity = move_and_slide(velocity+y_velocity, Vector3.UP)
	animate()
	
func animate():
	match state:
		EnemyState.IDLE:
			animator.play("idle")
		EnemyState.ALERTED:
			animator.play("alerted")
		EnemyState.ATTACKING:
			animator.play("running")

func start_chasing():
	state = EnemyState.ATTACKING
	
func _on_Area_body_entered(body):
	if body.name == "Player":
		body.take_damage(1)
		$Area/CollisionShape.disabled = true
		$Timer.start(3)


func _on_Timer_timeout():
	$Area/CollisionShape.disabled = false
