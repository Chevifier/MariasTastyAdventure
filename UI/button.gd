extends TextureButton

var animator

func _ready():
	animator =Tween.new()
	add_child(animator)
	connect("mouse_entered",self,"animate_button_hovered")
	connect("mouse_exited",self,"animate_button_exit")

func animate_button_hovered():
	animator.interpolate_property(self,"rect_scale",Vector2(1,1),Vector2(1.2,1.2), 0.2)
	animator.start()
func animate_button_exit():
	animator.interpolate_property(self,"rect_scale",rect_scale,Vector2(1.0,1.0), 0.2)
	animator.start()
