extends KinematicBody

export var npc = "npc name"
export var dialog_index = 0
onready var object = preload("res://gameobjects/pickups/coin_pickup.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("NPC")


func start_dialog():
	var dialog = Dialogic.start(npc + str(dialog_index))
	dialog.pause_mode = PAUSE_MODE_PROCESS
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_parent().add_child(dialog)
	Dialogic.set_variable("coins", 200)
	Dialogic.set_variable("pressalot_rep", GameManager.rep)
	dialog.connect("timeline_end",self,"end_dialog")
	dialog.connect("dialogic_signal",self,"dialogic_signal_event")
	get_tree().paused = true
	
func end_dialog(data):
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if npc == "pressalot":
		dialog_index = 1

func dialogic_signal_event(param):
	if param == "instance_coin":
		var coin = object.instance()
		get_parent().add_child(coin)
		coin.global_transform.origin = $Position3D.global_transform.origin
		
		
		
		
