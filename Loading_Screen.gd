extends Control

var loader
var loading_status
var root
var current_scene
var current_scene_name

onready var progress_bar = $ProgressBar
var level_addresses = {
	"the_hub": "res://levels/the hub.tscn",
	"level1": "res://levels/level1.tscn"
	
}

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	$Start_level_Button.visible = false
	root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count()-1)
	current_scene_name = "the_hub"
	

func load_level(level):
	current_scene_name = level
	current_scene.queue_free()
	loader = ResourceLoader.load_interactive(level_addresses[level])
	if loader == null:
		return
	visible = true
	set_process(true)
	
func _process(delta):
	if loader == null:
		set_process(false)
		return
		
	loading_status = loader.poll()
	if loading_status == ERR_FILE_EOF:
		progress_bar.value = 100
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		$Start_level_Button.visible = true
	elif loading_status == OK:
		update_progress()
		pass
	else:
		#error occured
		pass
		

func update_progress():
	var progress = float(loader.get_stage()) / loader.get_stage_count()
	progress_bar.value = progress * 100
	
	
	
	
func start_level(loaded_level):
	current_scene = loaded_level.instance()
	root.add_child(current_scene)
	



func _on_Start_level_Button_pressed():
	var loaded_level = loader.get_resource()
	visible = false
	loader = null
	start_level(loaded_level)
	$Start_level_Button.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
