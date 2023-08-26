extends Node

const SCREEN_SHOT_PATH:String = "res://renders/"

func takeScreenshot()->Image:
	return get_tree().get_root().get_texture().get_image()

func render()->void:
	var image:Image = takeScreenshot()
	
	image.save_png(SCREEN_SHOT_PATH + "/" + str(Time.get_unix_time_from_system()) + ".png" )
	

func _physics_process(_delta)->void:
	if Input.is_action_just_released("render"):
		render()
