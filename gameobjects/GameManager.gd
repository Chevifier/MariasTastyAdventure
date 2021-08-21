extends Node

var current_level = 1
var rep = 0
func _ready():
	pass

func complete_level():
	SaveSystem.add_level_data("level1", "score",1020)
	SaveSystem.add_level_data("level1", "completed", true)
	SaveSystem.save_data()

