extends Node


signal data_saved
signal data_loaded

const SAVE_DIR = "user://saves/"
var my_password = "0123456789"

var Save_Data = {
	"level1": {"name": "level_name", "score": 0, "collectable_found":false, "completed": false},
	"level2": {"name": "level","score": 0,"collectable_found": false,"completed": false},
	"level3": {"name": "level","score": 0,"collectable_found": false,"completed": false},
	"level4": {"name": "level","score": 0,"collectable_found": false,"completed": false},
	"level5": {"name": "level","score": 0,"collectable_found": false,"completed": false},
	"level6": {"name": "level","score": 0,"collectable_found": false,"completed": false},
	"level7": {"name": "level","score": 0,"collectable_found": false,"completed": false},
	"level8": {"name": "level","score": 0,"collectable_found": false,"completed": false},
	"level9": {"name": "level","score": 0,"collectable_found": false,"completed": false},
	"level10": {"name": "level","score": 0,"collectable_found": false,"completed": false},
	"level11": {"name": "level","score": 0,"collectable_found": false,"completed": false}
}

var file_path = SAVE_DIR + "mta_save.dat"


# Called when the node enters the scene tree for the first time.
func _ready():
	load_data()



func save_data():
	var dir = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)
		
	var save_file = File.new()
	save_file.open_encrypted_with_pass(file_path,File.WRITE,my_password)
	
	save_file.store_var(Save_Data)
	save_file.close()
	emit_signal("data_saved")
	print("data saved")
	

func load_data():
	var save_file = File.new()
	if save_file.file_exists(file_path):
		save_file.open_encrypted_with_pass(file_path,File.READ,my_password)
		Save_Data = save_file.get_var()
		save_file.close()
		emit_signal("data_loaded")
		#print("data loaded")
	else:
		#print("data doesnt exist")
		pass
		
func add_level_data(level,data_name,value):
	Save_Data[level][data_name] = value

func get_level_data(level):
	var data = Save_Data[level]
	return data
