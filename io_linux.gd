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

func recursive_search(org:String,filetypes:Array,path:String,dict:Dictionary):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin() 
		var file_name = dir.get_next()
		var starting_point = path.split("/")[-1]
		
		while file_name != "":
			if dir.current_is_dir():
				if !dict.has(file_name):
					dict[file_name] = { }
					recursive_search(org,filetypes,path+"/"+file_name,dict[file_name])
			else:
				if file_name.split(".")[-1] in filetypes:
					if !dict[org].has(starting_point):
						dict[org][starting_point] = []
					var item = {"title":file_name.split(".")[0],"url":path+"/"+file_name}
					dict[org][starting_point].append(item)

			file_name = dir.get_next()
	else:
		print("Couldnt find path for", path)

	return 1
	
