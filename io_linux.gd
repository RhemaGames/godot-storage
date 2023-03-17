extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func recursive_search(path,dict):
	
	var dir = DirAccess.open(path)
	if dir == OK:
		dir.list_dir_begin() # TODOGODOT4 fill missing arguments https://github.com/godotengine/godot/pull/40547
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				if !dict.has(file_name):
					dict[file_name] = {}
					recursive_search(path+"/"+file_name,dict[file_name])
			else:
				if file_name.split(".")[-1] in ["mp3","ogg","MP3","OGG"]:
					if !dict.has("songs"):
						dict["songs"] = []
					var item = {"title":file_name.split(".")[0],"url":path+"/"+file_name}
					dict["songs"].append(item)
				elif file_name.split(".")[-1] in ["png","jpg","JPEG","PNG","JPG"]:
					
					if !dict.has("pictures"):
						dict["pictures"] = []
					var item = {"title":file_name.split(".")[0],"url":path+"/"+file_name}
					dict["pictures"].append(item)
			file_name = dir.get_next()
	else:
		print("Couldnt find path for", path)
	return 1
