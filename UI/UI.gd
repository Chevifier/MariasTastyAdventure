extends CanvasLayer

onready var player_hp = $Game_Running/Player_HP
onready var score_label = $Game_Running/score_lbl
onready var Animator = $AnimationPlayer
onready var tween = $Tween
onready var cake_collected_view = $Game_Running/Cake_Collected
onready var cake_col_label = $Game_Running/Cake_Collected/HBoxContainer/cake_col_label

onready var game_ui = $"Game_Running"
onready var pause_ui = $"Game_Paused"
onready var game_over_ui = $"Game_Over"
onready var complete_ui = $"Game_Complete"

var last_hp_value = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	last_hp_value = get_parent().hp


func _process(delta):
	if Input.is_action_just_pressed("pause"):
		change_to_ui("pause")
	if last_hp_value != get_parent().hp:
		animate_hp_gauge()
		last_hp_value = get_parent().hp
		player_hp.value = get_parent().hp

func animate_hp_gauge():
	tween.interpolate_property(player_hp,"rect_position",Vector2(411.5,50),Vector2(411.5,0),1)
	tween.start()

func change_to_ui(ui):
	game_ui.visible = false
	pause_ui.visible = false
	game_over_ui.visible = false
	complete_ui.visible = false
	
	match ui:
		"pause":
			pause_ui.visible = true
			get_tree().paused = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		"resume":
			game_ui.visible = true
			get_tree().paused = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		"complete":
			complete_ui.visible = true
		"game_over":
			game_over_ui.visible = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)



func _on_Resume_button_pressed():
	change_to_ui("resume")


func _on_Quit_Button_pressed():
	get_tree().paused = false
	if LoadingScreen.current_scene_name == "the_hub":
		get_tree().quit()
	else:
		LoadingScreen.load_level("the_hub")


func _on_Retry_button_pressed():
	get_tree().paused = false
	LoadingScreen.load_level(LoadingScreen.current_scene_name)

func show_gate_info(make_visible:bool):
	cake_collected_view.visible = make_visible
